#import "ContactViewController.h"

@implementation ContactViewController

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        self.navigationItem.title = @"欣欣美甲";
        
        UIBarButtonItem *addShop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTaped)];
        UIBarButtonItem *switchShop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addButtonTaped)];
        self.navigationItem.rightBarButtonItems = @[switchShop, addShop];
        
        self.tabBarItem.title = @"名册";
        self.tabBarItem.image = [UIImage imageNamed:@"logo"];
    }
    return self;
}

-(void) loadView
{
    [super loadView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    header.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    label.text = @"会员";
    label.textAlignment = NSTextAlignmentCenter;
    
    UIButton *search = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    search.frame = CGRectMake(0, 0, 40, 40);
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    [search addTarget:self action:@selector(addButtonTaped) forControlEvents:UIControlEventTouchUpInside];
    
    [header addSubview:label];
    [header addSubview:search];
    
    self.tableView.tableHeaderView = header;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

-(void) addButtonTaped
{
    NSLog(@"hehe");
}

@end
