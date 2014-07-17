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

@implementation ContactViewController

{
    ContactDataSource *dataSource;
    EnterpriseDao *enterpriseDao;
    MemberDao *memberDao;
    SyncService *syncHelper;
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
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    NSNumber *time = [enterpriseDao queryLatestSyncTimeById:currentEnterpriseId];
    
    [syncHelper refreshMembersWithEnterpriseId:currentEnterpriseId LatestSyncTime:time Block:^(BOOL success){
        
        NSArray *membersTemp = [memberDao queryMembersByEnterpriseId:currentEnterpriseId];
        [self assembleMembers:membersTemp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ContactView *view = [[ContactView alloc] initWithController:self tableViewDataSource:dataSource];
            self.view = view;
        });
    }];
}

#pragma mark - search bar delegate

-(void) searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UserData *userData = [UserData load];
        NSString *currentEnterpriseId = userData.enterpriseId;
        
        NSArray *membersTemp = [memberDao fuzzyQueryMembersByEnterpriseId:currentEnterpriseId name:searchText];
        [self assembleMembers:membersTemp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ContactView* myView = (ContactView*)self.view;
            [myView.tableView reloadData];
        });
    });
}

#pragma mark - SwitchShopButtonDelegate

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self resolveView];
    });
}

@end
