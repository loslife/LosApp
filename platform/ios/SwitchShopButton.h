#import <UIKit/UIKit.h>
#import "LosDropDown.h"

@protocol SwitchShopButtonDelegate <NSObject>

-(void) enterpriseSelected:(NSString*)enterpriseId;

@end

@interface SwitchShopButton : UIBarButtonItem<LosDropDownDelegate>

-(id) initWithFrame:(CGRect)frame Delegate:(id<SwitchShopButtonDelegate>)delegate;

@end
