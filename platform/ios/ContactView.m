#import "ContactView.h"

@implementation ContactView

-(id) initWithController:(ContactViewController*)controller tableViewDataSource:(id<UITableViewDataSource, UITableViewDelegate>)ds
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    if (self) {
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
        searchBar.delegate = controller;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, 320, 415) style:UITableViewStylePlain];
        self.tableView.dataSource = ds;
        self.tableView.delegate = ds;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.sectionIndexColor = [UIColor grayColor];
        
        [self addSubview:searchBar];
        [self addSubview:self.tableView];
    }
    return self;
}

@end
