#import "LoginOrRegisterViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@implementation LoginOrRegisterViewController

-(void) loadView
{
    LoginOrRegisterView *view = [[LoginOrRegisterView alloc] initWithDelegate:self];
    self.view = view;
}

-(void) registerButtonTapped
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    vc.type = @"register";
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) loginButtonTapped
{
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
