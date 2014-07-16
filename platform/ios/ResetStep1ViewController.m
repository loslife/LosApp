#import "ResetStep1ViewController.h"
#import "LosHttpHelper.h"

@implementation ResetStep1ViewController

{
    NSTimer *timer;
    int resendCountdown;
    LosHttpHelper *httpHelper;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

@end
