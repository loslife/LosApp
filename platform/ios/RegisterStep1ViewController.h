#import <UIKit/UIKit.h>
#import "LosHttpHelper.h"
#import "LosAppUrls.h"
#import "StringUtils.h"

@interface RegisterStep1ViewController : UIViewController

-(void) requireVerificationCode;
-(void) submitButtonTapped;

@end
