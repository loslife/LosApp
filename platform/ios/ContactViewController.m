#import "ContactViewController.h"
#import "Member.h"
#import "StringUtils.h"
#import "MemberDetailViewController.h"
#import "ContactDataSource.h"
#import "EnterpriseDao.h"
#import "ContactNeverLoadView.h"
#import "ContactView.h"
#import "UserData.h"
#import "SyncService.h"
#import "LosHttpHelper.h"
#import "ContactLoadingView.h"
#import "LosAppUrls.h"
#import "MJRefresh.h"
#import "NoShopView.h"

@implementation ContactViewController

{
    ContactDataSource *dataSource;
    EnterpriseDao *enterpriseDao;
    
    NSString *previousEnterpriseId;
    NSString *currentEnterpriseId;
    
    BOOL searchLock;// to handle ios search bar bug
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        dataSource = [[ContactDataSource alloc] initWithController:self];
        enterpriseDao = [[EnterpriseDao alloc] init];
        
        searchLock = NO;
        
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        
        self.tabBarItem.title = @"会员";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_contact"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    UserData *userData = [UserData load];
    currentEnterpriseId = userData.enterpriseId;
    
    // 无关联店铺
    if([StringUtils isEmpty:currentEnterpriseId]){
        
        NoShopView *noShop = [[NoShopView alloc] initWithFrame:CGRectMake(0, 64, 320, 455)];
        self.view = noShop;
        
        self.navigationItem.title = @"我的店铺";
        
        return;
    }
    
    // 未切换店铺
    if([previousEnterpriseId isEqualToString:currentEnterpriseId]){
        return;
    }
    
    // 以下是切换了店铺的处理
    previousEnterpriseId = currentEnterpriseId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self resolveNavTitle];
        [self resolveView];
    });
}

-(void) viewWillDisappear:(BOOL)animated
{
    ContactView* myView = (ContactView*)self.view;
    if([myView isKindOfClass:[ContactView class]]){
        [myView.tableView deselectRowAtIndexPath:[myView.tableView indexPathForSelectedRow] animated:NO];
        myView.search.showsCancelButton = NO;
    }
}

-(void) resolveNavTitle
{
    NSString *enterpriseName = [enterpriseDao queryEnterpriseNameById:currentEnterpriseId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([StringUtils isEmpty:enterpriseName]){
            self.navigationItem.title = @"我的店铺";
        }else{
            self.navigationItem.title = enterpriseName;
        }
    });
}

// invoked in background thread
-(void) resolveView
{
    BOOL hasSync = [enterpriseDao querySyncFlagById:currentEnterpriseId];
    
    if(!hasSync){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ContactNeverLoadView *view = [[ContactNeverLoadView alloc] initWithController:self];
            self.view = view;
        });
    }else{
        
        [dataSource loadFromDatabaseWithEnterpriseId:currentEnterpriseId completionHandler:^(NSUInteger count){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ContactView *view = [[ContactView alloc] initWithController:self tableViewDataSource:dataSource];
                view.search.placeholder = [NSString stringWithFormat:@"共%lu位会员", count];
                self.view = view;
            });
        }];
    }
}

-(void) loadMembersFromServer
{
    BOOL network = [LosHttpHelper isNetworkAvailable];
    if(!network){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    BOOL wifi = [LosHttpHelper isWifi];
    if(!wifi){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您当前使用的是2G/3G网络，可能加载速度较慢。建议您在WIFI环境下加载会员。是否继续？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alert.tag = 23;
        [alert show];
        return;
    }
    
    [self doLoad];
}

-(void) pullToRefresh
{
    ContactView* myView = (ContactView*)self.view;
    NSString* searchText = myView.search.text;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [dataSource refreshWithEnterpriseId:currentEnterpriseId searchText:searchText completionHandler:^(int count){
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                myView.search.placeholder = [NSString stringWithFormat:@"共%d位会员", count];
                
                [myView.tableView headerEndRefreshing];
                [myView.tableView reloadData];
            });
        }];
    });
}

-(void) doLoad
{
    ContactLoadingView *loadingView = [[ContactLoadingView alloc] init];
    self.view = loadingView;
    
    [dataSource loadFromServiceWithEnterpriseId:currentEnterpriseId countHandler:^(NSUInteger count){
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [loadingView showMemberCount:count];
        });
        
    } completionHandler:^(NSUInteger count){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ContactView *view = [[ContactView alloc] initWithController:self tableViewDataSource:dataSource];
            view.search.placeholder = [NSString stringWithFormat:@"共%lu位会员", count];
            self.view = view;
        });
    }];
}

#pragma mark - search bar delegate

-(void) searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    if(searchLock){
        return;
    }
    
    searchLock = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [dataSource searchWithEnterpriseId:currentEnterpriseId searchText:searchText completionHandler:^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ContactView* myView = (ContactView*)self.view;
                [myView.tableView reloadData];
                
                searchLock = NO;
            });
        }];
    });
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    ContactView* myView = (ContactView*)self.view;
    myView.search.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    ContactView* myView = (ContactView*)self.view;
    myView.search.showsCancelButton = NO;
    [myView.search resignFirstResponder];
}

#pragma mark - SwitchShopButtonDelegate

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    UserData *userData = [UserData load];
    currentEnterpriseId = userData.enterpriseId;
    previousEnterpriseId = currentEnterpriseId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self resolveView];
    });
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 23){
        return;
    }
    
    switch (buttonIndex) {
        case 0:{
            break;
        }
        case 1:{
            [self doLoad];
            break;
        }
        default:{
            break;
        }
    }
}

@end
