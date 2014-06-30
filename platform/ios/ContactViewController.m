#import "ContactViewController.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "ContactView.h"
#import "Member.h"
#import "StringUtils.h"
#import "MemberDetailViewController.h"

@implementation ContactViewController

{
    BOOL membersInitDone;
    NSMutableArray *members;
    
    UISearchBar *searchBar;
    BOOL searchBarShow;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        membersInitDone = NO;
        members = [NSMutableArray array];
        
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        
        self.tabBarItem.title = @"会员";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_contact"];
        
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        searchBar.delegate = self;
        searchBarShow = NO;
    }
    return self;
}

-(void) loadView
{
    ContactView *view = [[ContactView alloc] initWithController:self];
    self.tableView = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initEnterprises];
        [self initMembers];
    });
}

#pragma mark - init data

-(void) initEnterprises
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if(!currentEnterpriseId){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = @"我的店铺";
        });
        return;
    }
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_name from enterprises where enterprise_id = :eid;", currentEnterpriseId];
    [rs next];
    NSString *enterpriseName = [rs objectForColumnName:@"enterprise_name"];
    
    [db close];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([StringUtils isEmpty:enterpriseName]){
            self.navigationItem.title = @"我的店铺";
        }else{
            self.navigationItem.title = enterpriseName;
        }
    });
}

-(void) initMembers
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([@"" isEqualToString:currentEnterpriseId]){
        return;
    }

    NSString *statement = @"select id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume from members where enterprise_id = :eid";
    [self refreshMembers:statement];
    
    membersInitDone = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - search bar delegate

-(void) searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [members removeAllObjects];
        
        NSString *base = @"select id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume from members where enterprise_id = :eid and name like '%%%@%%';";
        NSString *statement = [NSString stringWithFormat:base, searchText];
        
        [self refreshMembers:statement];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - private method

-(void) refreshMembers:(NSString*)statement
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    NSMutableArray *membersTemp = [NSMutableArray array];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:statement, currentEnterpriseId];
    while ([rs next]) {
        
        NSString *pk = [rs objectForColumnName:@"id"];
        NSString *name = [rs objectForColumnName:@"name"];
        NSNumber *birthday = [rs objectForColumnName:@"birthday"];
        NSString *phone = [rs objectForColumnName:@"phoneMobile"];
        NSNumber *joinDate = [rs objectForColumnName:@"joinDate"];
        NSString *memberNo = [rs objectForColumnName:@"memberNo"];
        NSNumber *latest = [rs objectForColumnName:@"latestConsumeTime"];
        NSNumber *totalConsume = [rs objectForColumnName:@"totalConsume"];
        NSNumber *averageConsume = [rs objectForColumnName:@"averageConsume"];
        
        Member *member = [[Member alloc] initWithPk:pk Name:name Birthday:birthday Phone:phone JoinDate:joinDate MemberNo:memberNo LatestConsume:latest TotalConsume:totalConsume AverageConsume:averageConsume];
        [membersTemp addObject:member];
    }
    
    [db close];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    for (Member *member in membersTemp) {
        NSInteger sect = [collation sectionForObject:member collationStringSelector:@selector(name)];
        member.sectionNumber = sect;
    }
    
    NSInteger highSection = [[collation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (Member *member in membersTemp) {
        [(NSMutableArray*)[sectionArrays objectAtIndex:member.sectionNumber] addObject:member];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [members addObject:sortedSection];
    }
}

-(void) searchButtonTapped
{
    [self.view addSubview:searchBar];
    searchBarShow = YES;
}

-(void) hideSubViews:(UITapGestureRecognizer *)recognizer
{
    if(searchBarShow){
        [searchBar resignFirstResponder];
        [searchBar removeFromSuperview];
        searchBarShow = NO;
    }
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!membersInitDone){
        return 1;
    }
    return [members count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!membersInitDone){
        return 0;
    }
    
    return [[members objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!membersInitDone){
        return nil;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    Member *member = [[members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = member.name;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(!membersInitDone){
        return @[];
    }
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!membersInitDone){
        return nil;
    }
    
    if ([[members objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*)view;
    
    headerView.textLabel.text = [@"    " stringByAppendingString:headerView.textLabel.text];// sorry for this
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *member = [[members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MemberDetailViewController *detail = [[MemberDetailViewController alloc] initWithMember:member];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - SwitchShopButtonDelegate

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [members removeAllObjects];
        NSString *statement = @"select id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume from members where enterprise_id = :eid";
        [self refreshMembers:statement];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

@end
