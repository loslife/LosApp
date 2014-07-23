#import <UIKit/UIKit.h>
#import "SwitchShopButton.h"

@interface ContactViewController : UIViewController<UISearchBarDelegate, SwitchShopButtonDelegate, UIAlertViewDelegate>

-(void) loadMembersFromServer;
-(void) pullToRefresh;
-(void) onSingleTap;

@end