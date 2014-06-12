#import "LoginViewController.h"
#import "LoginView.h"

@implementation LoginViewController

-(void) loadView
{
    LoginView *view = [[LoginView alloc] initWithController:self];
    self.view = view;
}

-(void) loginButtonPressed
{
    // 调用登陆接口
    LoginView* theView = (LoginView*)self.view;
    NSString *userId = theView.username.text;
    
    [UserData writeUserId:userId];
    
    BootstrapViewController *bootstrap = [[BootstrapViewController alloc] init];
    [self presentViewController:bootstrap animated:YES completion:nil];
}

@end
