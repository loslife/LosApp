#import "ContactViewController.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "ContactView.h"
#import "Member.h"

@implementation ContactViewController

{
    BOOL membersInitDone;
    NSMutableArray *members;
    
    NSMutableArray *enterprises;
    NSString *currentEnterpriseId;
    
    UISearchBar *searchBar;
    BOOL searchBarShow;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        membersInitDone = NO;
        members = [NSMutableArray array];
        
        enterprises = [NSMutableArray array];
        currentEnterpriseId = @"";
        
        UIButton *addShop = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [addShop setBackgroundImage:[UIImage imageNamed:@"add_shop"] forState:UIControlStateNormal];
        [addShop addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addShopItem = [[UIBarButtonItem alloc] initWithCustomView:addShop];
        
        UIButton *switchShop = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [switchShop setBackgroundImage:[UIImage imageNamed:@"switch_shop"] forState:UIControlStateNormal];
        [switchShop addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *switchShopItem = [[UIBarButtonItem alloc] initWithCustomView:switchShop];
        
        self.navigationItem.rightBarButtonItems = @[switchShopItem, addShopItem];

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
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_id, enterprise_name from enterprises;"];
    while ([rs next]) {
        NSString *pk = [rs objectForColumnName:@"enterprise_id"];
        NSString *name = [rs objectForColumnName:@"enterprise_name"];
        NSDictionary *enterprise = [NSDictionary dictionaryWithObjects:@[pk, name] forKeys:@[@"id", @"name"]];
        [enterprises addObject:enterprise];
    }
    
    [db close];
    
    NSUInteger count = [enterprises count];
    if(count > 0){
        currentEnterpriseId = [[enterprises firstObject] objectForKey:@"id"];
    }else{
        currentEnterpriseId = @"";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(count > 0){
            self.navigationItem.title = [[enterprises firstObject] objectForKey:@"name"];
        }else{
            self.navigationItem.title = @"我的店铺";
        }
    });
}

-(void) initMembers
{
    // 无关联企业，不查询
    if([@"" isEqualToString:currentEnterpriseId]){
        return;
    }

    NSString *statement = @"select id, name from members where enterprise_id = :eid";
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
        
        NSString *base = @"select id, name from members where enterprise_id = :eid and name like '%%%@%%';";
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
    NSMutableArray *membersTemp = [NSMutableArray array];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:statement, currentEnterpriseId];
    while ([rs next]) {
        NSString *pk = [rs objectForColumnName:@"id"];
        NSString *name = [rs objectForColumnName:@"name"];
        Member *member = [[Member alloc] initWithPk:pk Name:name];
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

#pragma mark - responder

-(void) addButtonTapped
{
    NSLog(@"hehe");
}

-(void) searchButtonTapped
{
    [self.view addSubview:searchBar];
    searchBarShow = YES;
}

-(void) hideSearchBar
{
    if(!searchBarShow){
        return;
    }
    
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    searchBarShow = NO;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(!membersInitDone){
        return nil;
    }
    
    if ([[members objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

@end
