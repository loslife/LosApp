#import <UIKit/UIKit.h>
#import "LosTimePicker.h"
#import "SwitchShopButton.h"
#import "ReportDao.h"
#import "EnterpriseDao.h"
#import "LosHttpHelper.h"
#import "LosAppUrls.h"

@interface ReportViewControllerBase : UIViewController<LosTimePickerDelegate, SwitchShopButtonDelegate>

@property ReportDao *reportDao;
@property EnterpriseDao *enterpriseDao;
@property LosHttpHelper *httpHelper;

-(void) initEnterprises;
- (void) handleSwipeLeft;
- (void) handleSwipeRight;

@end
