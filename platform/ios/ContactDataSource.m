#import "ContactDataSource.h"
#import "Member.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "MemberDetailViewController.h"
#import "MemberTableViewCell.h"
#import "MemberDao.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"
#import "EnterpriseDao.h"
#import "SyncService.h"
#import "StringUtils.h"

@implementation ContactDataSource

{
    ContactViewController *controller;
    MemberDao *memberDao;
    LosHttpHelper *httpHelper;
    EnterpriseDao *enterpriseDao;
    SyncService *syncHelper;
    
    NSMutableArray *members;
}

-(id) initWithController:(ContactViewController*)viewController
{
    self = [super init];
    if(self){
        
        controller = viewController;
        memberDao = [[MemberDao alloc] init];
        httpHelper = [[LosHttpHelper alloc] init];
        enterpriseDao = [[EnterpriseDao alloc] init];
        syncHelper = [[SyncService alloc] init];
        
        members = [NSMutableArray array];
    }
    return self;
}

-(void) loadFromDatabaseWithEnterpriseId:(NSString*)enterpriseId completionHandler:(void(^)(NSUInteger count))block;
{
    NSArray *membersTemp = [memberDao queryMembersByEnterpriseId:enterpriseId];
    
    NSTimeInterval p1 = [[NSDate date] timeIntervalSince1970];
    [self assembleMembers:membersTemp];
    NSTimeInterval p2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"assemble spend: %f", p2 - p1);
    
    block([membersTemp count]);
}

-(void) loadFromServiceWithEnterpriseId:(NSString*)enterpriseId countHandler:(void(^)(NSUInteger count))countHandler completionHandler:(void(^)(NSUInteger count))completionHandler
{
    NSString *url = [NSString stringWithFormat:COUNT_MEMBERS_URL, enterpriseId];
    
    [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
        
        NSDictionary *result = [dict objectForKey:@"result"];
        NSNumber *count = [result objectForKey:@"count"];
        countHandler([count longValue]);
        
        NSNumber *time = [enterpriseDao queryLatestSyncTimeById:enterpriseId];
        
        [syncHelper refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:time Block:^(BOOL success){
            
            NSArray *membersTemp = [memberDao queryMembersByEnterpriseId:enterpriseId];
            [self assembleMembers:membersTemp];
            completionHandler([membersTemp count]);
        }];
    }];
}

-(void) refreshWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)(int count))block
{
    NSNumber *time = [enterpriseDao queryLatestSyncTimeById:enterpriseId];
    
    [syncHelper refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:time Block:^(BOOL success){
        
        NSArray *membersTemp;
        if(![StringUtils isEmpty:searchText]){
            membersTemp = [memberDao fuzzyQueryMembersByEnterpriseId:enterpriseId name:searchText];
        }else{
            membersTemp = [memberDao queryMembersByEnterpriseId:enterpriseId];
        }
        [self assembleMembers:membersTemp];
        
        int totalCount = [memberDao countMembersByEnterpriseId:enterpriseId];
        block(totalCount);
    }];
}

-(void) searchWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)())block
{
    NSArray *membersTemp;
    
    if(![StringUtils isEmpty:searchText]){
        membersTemp = [memberDao fuzzyQueryMembersByEnterpriseId:enterpriseId name:searchText];
    }else{
        membersTemp = [memberDao queryMembersByEnterpriseId:enterpriseId];
    }
    
    [self assembleMembers:membersTemp];
    
    block();
}

// slow method
-(void) assembleMembers:(NSArray*)origin
{
    [members removeAllObjects];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    // slow point 1: takes 1.5 seconds when 400 records
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
    
    // slow point 2: takes 1.3 seconds when 400 records
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [collation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        [members addObject:sortedSection];
    }
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [members count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[members objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MemberTableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    Member *member = [[members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = member.name;
    cell.cardsLabel.text = member.cardStr;
    cell.consumeLabel.text = member.consumeDesc;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[members objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*)view;
    headerView.textLabel.text = [@"     " stringByAppendingString:headerView.textLabel.text];// sorry for this
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
    [controller.navigationController pushViewController:detail animated:YES];
}

@end
