#import "AboutUsViewController.h"
#import "AboutUsView.h"

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"关于乐斯";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void) loadView
{
    AboutUsView *view = [[AboutUsView alloc] init];
    self.view = view;
}

@end
