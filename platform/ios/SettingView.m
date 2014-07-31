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
        
        [self addSubview:self.tableView];
    }
    return self;
}

@end
