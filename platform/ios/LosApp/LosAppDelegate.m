#import "LosAppDelegate.h"
#import "LosStyles.h"
#import <Crashlytics/Crashlytics.h>

@implementation LosAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"1ccc56a1bdc94acb876fd76e5193e91160a4d3f6"];
    
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
