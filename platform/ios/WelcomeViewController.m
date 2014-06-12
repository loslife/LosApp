#import "WelcomeViewController.h"

@implementation WelcomeViewController

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
    BootstrapViewController *login = [[BootstrapViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

// 跳转到login页面
- (void) jumpToLogin
{
    LoginViewController *login = [[LoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}

@end
