#import "ContactView.h"

@implementation ContactView

-(id) initWithController:(ContactViewController*)controller
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    if (self) {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
        searchBar.delegate = controller;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 468) style:UITableViewStylePlain];
        self.tableView.dataSource = controller;
        self.tableView.delegate = controller;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.sectionIndexColor = [UIColor grayColor];
        
        [self addSubview:searchBar];
        [self addSubview:self.tableView];
    }
    return self;
}

@end
