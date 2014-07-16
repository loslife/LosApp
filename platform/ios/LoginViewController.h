#import <UIKit/UIKit.h>
#import "UserData.h"
#import "BootstrapViewController.h"
#import "LosHttpHelper.h"
#import "LosAppUrls.h"

@interface LoginViewController : UIViewController

-(void) loginButtonPressed;
-(void) resetButtonPressed;
-(void) setUserNameAfterRegister:(NSString*)phone;

@end
