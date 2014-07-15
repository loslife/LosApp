#import "LoginOrRegisterViewController.h"
#import "LoginViewController.h"
#import "RegisterStep1ViewController.h"

@implementation LoginOrRegisterViewController

-(void) loadView
{
    LoginOrRegisterView *view = [[LoginOrRegisterView alloc] initWithDelegate:self];
    self.view = view;
}

-(void) registerButtonTapped
{
    RegisterStep1ViewController *vc = [[RegisterStep1ViewController alloc] init];
    vc.type = @"register";
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) loginButtonTapped
{
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
