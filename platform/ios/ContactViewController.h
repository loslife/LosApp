#import <UIKit/UIKit.h>
#import "LosDropDown.h"

@interface ContactViewController : UITableViewController<UISearchBarDelegate, LosDropDownDelegate>

-(void) searchButtonTapped;
-(void) hideSubViews:(UITapGestureRecognizer *)recognizer;

@end
