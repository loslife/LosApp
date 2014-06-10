#import "FirstViewController.h"

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [label setText:@"hehe"];
    
    [view addSubview:label];
    self.view = view;
}

@end
