#import "LoginOrRegisterViewController.h"
#import "LoginViewController.h"
#import "RegisterStep1ViewController.h"
#import "StringUtils.h"

@implementation LoginOrRegisterViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.preparePhone = @"";
    }
    return self;
}

-(void) loadView
{
    LoginOrRegisterView *view = [[LoginOrRegisterView alloc] initWithDelegate:self];
    self.view = view;
}

-(void) viewDidAppear:(BOOL)animated
{
    if([StringUtils isEmpty:self.preparePhone]){
        return;
    }
    
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self presentViewController:controller animated:YES completion:^{
        [controller setUserNameAfterRegister:self.preparePhone];
        self.preparePhone = @"";
    }];
}

-(void) registerButtonTapped
{
    RegisterStep1ViewController *vc = [[RegisterStep1ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void) loginButtonTapped
{
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
