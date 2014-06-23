#import "ContactViewController.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "ContactView.h"
#import "Member.h"
#import "AddShopViewController.h"
#import "StringUtils.h"
#import "MemberDetailViewController.h"

@implementation ContactViewController

{
    BOOL membersInitDone;
    NSMutableArray *members;
    
    NSMutableArray *enterprises;
    NSString *currentEnterpriseId;
    
    UISearchBar *searchBar;
    BOOL searchBarShow;
    LosDropDown *dropDown;
    BOOL dropDownShow;
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
        [switchShop addTarget:self action:@selector(switchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *switchShopItem = [[UIBarButtonItem alloc] initWithCustomView:switchShop];
        
        self.navigationItem.rightBarButtonItems = @[switchShopItem, addShopItem];

        self.tabBarItem.title = @"会员";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_contact"];
        
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        searchBar.delegate = self;
        searchBarShow = NO;
        
        dropDownShow = NO;
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

-(void) closeSwitchShopMenu{
    
    if(!dropDownShow){
        return;
    }
    
    [dropDown removeFromSuperview];
    
    UIBarButtonItem *switchButton = [self.navigationItem.rightBarButtonItems firstObject];
    [(UIButton*)switchButton.customView setBackgroundImage:[UIImage imageNamed:@"switch_shop"] forState:UIControlStateNormal];
    
    dropDownShow = NO;
}

#pragma mark - responder

-(void) addButtonTapped
{
    AddShopViewController *addShop = [[AddShopViewController alloc] init];
    [self.navigationController pushViewController:addShop animated:YES];
}

-(void) switchButtonTapped
{
    if(dropDownShow){
        [self closeSwitchShopMenu];
        return;
    }
    
    if([enterprises count] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有店铺，请先关联" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
    
    for(NSDictionary *dict in enterprises){
        
        NSString *enterpriseId = [dict objectForKey:@"id"];
        NSString *enterpriseName = [dict objectForKey:@"name"];
        if([StringUtils isEmpty:enterpriseName]){
            enterpriseName = @"我的店铺";
        }
        
        LosDropDownItem *item = [[LosDropDownItem alloc] initWithTitle:enterpriseName value:enterpriseId];
        [items addObject:item];
    }
    
    dropDown = [[LosDropDown alloc] initWithFrame:CGRectMake(150, 20, 150, 28) MenuItems:items Delegate:self];
    
    [self.view addSubview:dropDown];
    
    UIBarButtonItem *switchButton = [self.navigationItem.rightBarButtonItems firstObject];
    [(UIButton*)switchButton.customView setBackgroundImage:[UIImage imageNamed:@"switch_shop_close"] forState:UIControlStateNormal];
    dropDownShow = YES;
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

#pragma mark - drop down delegate

-(void) menuItemTapped:(NSString*)value
{
    if([currentEnterpriseId isEqualToString:value]){
        [self closeSwitchShopMenu];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        currentEnterpriseId = value;
        
        [members removeAllObjects];
        NSString *statement = @"select id, name from members where enterprise_id = :eid";
        [self refreshMembers:statement];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSString* enterpriseName;
            
            for(NSDictionary *dict in enterprises){
                NSString *enterpriseId = [dict objectForKey:@"id"];
                if(![enterpriseId isEqualToString:value]){
                    break;
                }
                enterpriseName = [dict objectForKey:@"name"];
            }
            
            if(!enterpriseName){
                enterpriseName = @"我的店铺";
            }
            
            self.navigationItem.title = enterpriseName;
            [self.tableView reloadData];
            
            [self closeSwitchShopMenu];
        });
    });
}

@end
