#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void) loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 480)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [label setText:@"hehe"];
    
    [view addSubview:label];
    self.view = view;
}

@end
