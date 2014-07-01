#import <UIKit/UIKit.h>
#import "LosTimePicker.h"
#import "SwitchShopButton.h"

@interface ReportViewControllerBase : UIViewController<LosTimePickerDelegate, SwitchShopButtonDelegate>

- (void) handleSwipeLeft;
- (void) handleSwipeRight;

@end
