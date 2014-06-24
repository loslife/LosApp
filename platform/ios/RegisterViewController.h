#import <UIKit/UIKit.h>
#import "LosHttpHelper.h"
#import "LosAppUrls.h"
#import "StringUtils.h"

@interface RegisterViewController : UIViewController

@property NSString* type;

-(void) requireVerificationCode;
-(void) registerButtonPressed;

@end
