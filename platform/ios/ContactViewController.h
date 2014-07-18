#import <UIKit/UIKit.h>
#import "SwitchShopButton.h"

@interface ContactViewController : UIViewController<UISearchBarDelegate, SwitchShopButtonDelegate, UIAlertViewDelegate>

@property NSString *previousEnterpriseId;

-(void) loadMembersFromServer;

@end