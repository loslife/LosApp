#import "ContactViewController.h"
#import "Member.h"
#import "StringUtils.h"
#import "MemberDetailViewController.h"
#import "ContactDataSource.h"
#import "EnterpriseDao.h"
#import "ContactNeverLoadView.h"
#import "ContactView.h"
#import "MemberDao.h"
#import "UserData.h"
#import "SyncService.h"
#import "LosHttpHelper.h"
#import "ContactLoadingView.h"
#import "LosAppUrls.h"
#import "MJRefresh.h"

@implementation ContactViewController

{
    ContactDataSource *dataSource;
    EnterpriseDao *enterpriseDao;
    MemberDao *memberDao;
    SyncService *syncHelper;
    LosHttpHelper *httpHelper;
    BOOL searchLock;// to handle ios search bar bug
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        self.previousEnterpriseId = @"";
        
        dataSource = [[ContactDataSource alloc] initWithController:self];
        enterpriseDao = [[EnterpriseDao alloc] init];
        memberDao = [[MemberDao alloc] init];
        syncHelper = [[SyncService alloc] init];
        httpHelper = [[LosHttpHelper alloc] init];
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
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([self.previousEnterpriseId isEqualToString:currentEnterpriseId]){
        return;
    }
    
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
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if(!currentEnterpriseId){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = @"我的店铺";
        });
        return;
    }
    
    NSString *enterpriseName = [enterpriseDao queryEnterpriseNameById:currentEnterpriseId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([StringUtils isEmpty:enterpriseName]){
            self.navigationItem.title = @"我的店铺";
        }else{
            self.navigationItem.title = enterpriseName;
        }
    });
}

-(void) resolveView
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if(!currentEnterpriseId){
        return;
    }
    
    self.previousEnterpriseId = currentEnterpriseId;
    
    BOOL hasSync = [enterpriseDao querySyncFlagById:currentEnterpriseId];
    
    if(!hasSync){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ContactNeverLoadView *view = [[ContactNeverLoadView alloc] initWithController:self];
            self.view = view;
        });
    }else{
        
        NSArray *membersTemp = [memberDao queryMembersByEnterpriseId:currentEnterpriseId];
        [self assembleMembers:membersTemp];

        dispatch_async(dispatch_get_main_queue(), ^{
            ContactView *view = [[ContactView alloc] initWithController:self tableViewDataSource:dataSource];
            view.search.placeholder = [NSString stringWithFormat:@"共%lu位会员", [membersTemp count]];
            self.view = view;
        });
    }
}

-(void) assembleMembers:(NSArray*)origin
{
    [dataSource.members removeAllObjects];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    for (Member *member in origin) {
        NSInteger sect = [collation sectionForObject:member collationStringSelector:@selector(name)];
        member.sectionNumber = sect;
    }
    
    NSInteger highSection = [[collation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Member *member in origin) {
        [(NSMutableArray*)[sectionArrays objectAtIndex:member.sectionNumber] addObject:member];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [dataSource.members addObject:sortedSection];
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UserData *userData = [UserData load];
        NSString *currentEnterpriseId = userData.enterpriseId;
        
        NSNumber *time = [enterpriseDao queryLatestSyncTimeById:currentEnterpriseId];
        
        [syncHelper refreshMembersWithEnterpriseId:currentEnterpriseId LatestSyncTime:time Block:^(BOOL success){
            
            ContactView* myView = (ContactView*)self.view;
            NSString* searchText = myView.search.text;
            
            NSArray *membersTemp;
            if(![StringUtils isEmpty:searchText]){
                membersTemp = [memberDao fuzzyQueryMembersByEnterpriseId:currentEnterpriseId name:searchText];
            }else{
                membersTemp = [memberDao queryMembersByEnterpriseId:currentEnterpriseId];
            }
            [self assembleMembers:membersTemp];
            
            int totalCount = [memberDao countMembersByEnterpriseId:currentEnterpriseId];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                myView.search.placeholder = [NSString stringWithFormat:@"共%d位会员", totalCount];
                
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
    
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    NSString *url = [NSString stringWithFormat:COUNT_MEMBERS_URL, currentEnterpriseId];
    [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSDictionary *result = [dict objectForKey:@"result"];
            NSNumber *count = [result objectForKey:@"count"];
            [loadingView showMemberCount:[count intValue]];
            
            NSNumber *time = [enterpriseDao queryLatestSyncTimeById:currentEnterpriseId];
            
            [syncHelper refreshMembersWithEnterpriseId:currentEnterpriseId LatestSyncTime:time Block:^(BOOL success){
                
                NSArray *membersTemp = [memberDao queryMembersByEnterpriseId:currentEnterpriseId];
                [self assembleMembers:membersTemp];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    ContactView *view = [[ContactView alloc] initWithController:self tableViewDataSource:dataSource];
                    view.search.placeholder = [NSString stringWithFormat:@"共%lu位会员", [membersTemp count]];
                    self.view = view;
                });
            }];
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
    
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *membersTemp;
        if(![StringUtils isEmpty:searchText]){
            membersTemp = [memberDao fuzzyQueryMembersByEnterpriseId:currentEnterpriseId name:searchText];
        }else{
            membersTemp = [memberDao queryMembersByEnterpriseId:currentEnterpriseId];
        }
        [self assembleMembers:membersTemp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ContactView* myView = (ContactView*)self.view;
            [myView.tableView reloadData];
            
            searchLock = NO;
        });
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
