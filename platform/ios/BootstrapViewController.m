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
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(160, 284);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    
}

@end
