#import "LosAppDelegate.h"
#import "LosStyles.h"

@implementation LosAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    self.window.rootViewController = welcome;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UINavigationBar appearance] setBarTintColor:BLUE1];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [[UITabBar appearance] setBarTintColor:GRAY3];// 背景色
    [[UITabBar appearance] setSelectedImageTintColor:BLUE1];// 选中图标颜色
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
