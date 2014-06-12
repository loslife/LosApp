#import "LoginViewController.h"
#import "LoginView.h"

@implementation LoginViewController

{
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

-(void) loadView
{
    LoginView *view = [[LoginView alloc] initWithController:self];
    self.view = view;
}

-(void) loginButtonPressed
{
    [httpHelper getSecure:TEST_URL completionHandler:^(NSDictionary *dict){
    
    }];
    
    
    LoginView* theView = (LoginView*)self.view;
    NSString *userId = theView.username.text;
    
    [UserData writeUserId:userId];
    
    BootstrapViewController *bootstrap = [[BootstrapViewController alloc] init];
    [self presentViewController:bootstrap animated:YES completion:nil];
}

@end
