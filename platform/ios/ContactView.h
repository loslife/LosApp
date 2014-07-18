#import <UIKit/UIKit.h>
#import "ContactViewController.h"

@interface ContactView : UIView

@property UISearchBar *search;
@property UITableView *tableView;

-(id) initWithController:(ContactViewController*)controller tableViewDataSource:(id<UITableViewDataSource, UITableViewDelegate>)ds;

@end
