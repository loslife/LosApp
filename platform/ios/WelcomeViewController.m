#import "WelcomeViewController.h"
#import "UserData.h"
#import "LoginOrRegisterViewController.h"
#import "BootstrapViewController.h"

@implementation WelcomeViewController

-(void) loadView
{
    [super loadView];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bootstrap"]];
}

-(void) viewDidAppear:(BOOL)animated
{
    if([self hasLogin]){
        [self jumpToBootstrap];
    }else{
        [self jumpToLogin];
    }
}

#pragma mark - private method

-(BOOL) hasLogin
{
    UserData *userData = [UserData load];
    NSString *userId = userData.userId;
    return (userId != nil);
}

// 跳转到bootstrap
- (void) jumpToBootstrap
{
    BootstrapViewController *bootstrap = [[BootstrapViewController alloc] init];
    [self presentViewController:bootstrap animated:YES completion:nil];
}

// 跳转到login页面
- (void) jumpToLogin
{
    LoginOrRegisterViewController *login = [[LoginOrRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

@end
