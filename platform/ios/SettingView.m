#import "SettingView.h"

@implementation SettingView

-(id) initWithController:(SettingViewController*)controller
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if(self){
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 468) style:UITableViewStylePlain];
        self.tableView.dataSource = controller;
        self.tableView.delegate = controller;
        [self.tableView setScrollEnabled:NO];
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.tableView.tableFooterView = [[UIView alloc] init];
        
        UIButton *logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        logout.frame = CGRectMake(10, 450, 300, 50);
        [logout setTitle:@"退出" forState:UIControlStateNormal];
        logout.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        logout.tintColor = [UIColor whiteColor];
        logout.layer.cornerRadius = 5;
        [logout addTarget:controller action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.tableView];
        [self addSubview:logout];
    }
    return self;
}

@end
