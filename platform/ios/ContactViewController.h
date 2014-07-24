#import <UIKit/UIKit.h>
#import "SwitchShopButton.h"
#import "ContactDataSource.h"

@interface ContactViewController : UIViewController<UISearchBarDelegate, SwitchShopButtonDelegate, UIAlertViewDelegate, ContactDataSourceDelegate>

-(void) loadMembersFromServer;
-(void) pullToRefresh;
-(void) onSingleTap;

@end