#import <UIKit/UIKit.h>
#import "LosHttpHelper.h"
#import "LosAppUrls.h"
#import "UserData.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"

@interface AddShopViewController : UIViewController

-(void) requireVerificationCode;
-(void) appendEnterprise;

@end
