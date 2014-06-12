#import "BootstrapViewController.h"
#import "BootstrapView.h"

@implementation BootstrapViewController

-(void) loadView
{
    BootstrapView *view = [[BootstrapView alloc] init];
    self.view = view;
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"1");
}

@end
