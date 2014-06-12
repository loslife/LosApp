#import "BootstrapViewController.h"

@implementation BootstrapViewController

-(void) loadView
{
    UIView *view  = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    label.text = @"bootstrap";
    
    [view addSubview:label];
    self.view = view;
}

@end
