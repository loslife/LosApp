#import <UIKit/UIKit.h>
#import "SwitchShopButton.h"

@interface ContactViewController : UITableViewController<UISearchBarDelegate, SwitchShopButtonDelegate>

-(void) searchButtonTapped;
-(void) hideSubViews:(UITapGestureRecognizer *)recognizer;

@end
