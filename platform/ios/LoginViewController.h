#import <UIKit/UIKit.h>
#import "UserData.h"
#import "BootstrapViewController.h"
#import "LosHttpHelper.h"
#import "LosAppUrls.h"
#import "RegisterViewController.h"

@interface LoginViewController : UIViewController

-(void) setUserNameAfterRegister:(NSString*)phoneNumber;
-(void) loginButtonPressed;
-(void) registerButtonPressed;
-(void) resetButtonPressed;

@end
