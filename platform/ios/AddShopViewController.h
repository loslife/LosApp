#import <UIKit/UIKit.h>
#import "LosHttpHelper.h"
#import "LosAppUrls.h"
#import "UserData.h"
#import "SyncService.h"
#import "EnterpriseListView.h"

@interface AddShopViewController : UIViewController<EnterpriseListViewDelegate>

-(void) requireVerificationCode;
-(void) appendEnterprise;

@end
