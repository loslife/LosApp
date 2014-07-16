#import <UIKit/UIKit.h>
#import "SwitchShopButton.h"

@interface ContactViewController : UIViewController<UISearchBarDelegate, SwitchShopButtonDelegate>

@property NSString *previousEnterpriseId;

-(void) loadMembersFromServer;

@end