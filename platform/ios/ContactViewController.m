#import "ContactViewController.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "ContactView.h"

@implementation ContactViewController

{
    BOOL loadMembersDone;
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
        
        loadMembersDone = NO;
        
        members = [NSMutableArray array];
        enterprises = [NSMutableArray array];
        currentEnterpriseId = @"";
        
        UIBarButtonItem *addShop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
        UIBarButtonItem *switchShop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addButtonTapped)];
        self.navigationItem.rightBarButtonItems = @[switchShop, addShop];
        
        self.tabBarItem.title = @"名册";
        self.tabBarItem.image = [UIImage imageNamed:@"logo"];
        
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        searchBarShow = NO;
    }
    return self;
}

-(void) loadView
{
    ContactView *view = [[ContactView alloc] initWithController:self];
    self.tableView = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadEnterprises];
        [self loadMembers];
    });
}

#pragma mark - load data from db

-(void) loadEnterprises
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

-(void) loadMembers
{
    // 无关联企业
    if([@"" isEqualToString:currentEnterpriseId]){
        return;
    }
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select id, name from members where enterprise_id = :eid", currentEnterpriseId];
    while ([rs next]) {
        NSString *pk = [rs objectForColumnName:@"id"];
        NSString *name = [rs objectForColumnName:@"name"];
        NSDictionary *member = [NSDictionary dictionaryWithObjects:@[pk, name] forKeys:@[@"id", @"name"]];
        [members addObject:member];
    }
    
    [db close];
    
    loadMembersDone = YES;
    [self.tableView reloadData];
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

-(void) resignOnTap
{
    if(!searchBarShow){
        return;
    }
    
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
    searchBarShow = NO;
}

#pragma mark - datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!loadMembersDone){
        return 0;
    }
    
    return [members count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!loadMembersDone){
        return nil;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    cell.textLabel.text = [[members objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

@end
