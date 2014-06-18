#import "LosAppDelegate.h"

@implementation LosAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    WelcomeViewController *welcome = [[WelcomeViewController alloc] init];
    self.window.rootViewController = welcome;
    
    UIColor *color = [UIColor colorWithRed:107/255.0f green:211/255.0f blue:217/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:color];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
