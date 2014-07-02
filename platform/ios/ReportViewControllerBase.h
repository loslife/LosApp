#import <UIKit/UIKit.h>
#import "LosTimePicker.h"
#import "SwitchShopButton.h"
#import "LosDao.h"

@interface ReportViewControllerBase : UIViewController<LosTimePickerDelegate, SwitchShopButtonDelegate>

@property LosDao *dao;

-(void) initEnterprises;
- (void) handleSwipeLeft;
- (void) handleSwipeRight;

@end
