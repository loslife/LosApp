#import <UIKit/UIKit.h>

@interface ContactViewController : UITableViewController<UISearchBarDelegate>

-(void) searchButtonTapped;
-(void) hideSearchBar;

@end
