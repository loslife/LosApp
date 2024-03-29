#import "ContactView.h"
#import "MJRefresh.h"

@implementation ContactView

-(id) initWithController:(ContactViewController*)controller tableViewDataSource:(id<UITableViewDataSource, UITableViewDelegate>)ds
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    if (self) {
        
        self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
        self.search.delegate = controller;
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, 320, screenHeight - 153) style:UITableViewStylePlain];
        self.tableView.dataSource = ds;
        self.tableView.delegate = ds;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.sectionIndexColor = [UIColor grayColor];
        [self.tableView addHeaderWithTarget:controller action:@selector(pullToRefresh) dateKey:@"mjrefresh_date_contact"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(onSingleTap)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.search];
        [self addSubview:self.tableView];
    }
    return self;
}

@end
