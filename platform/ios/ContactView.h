#import <UIKit/UIKit.h>
#import "ContactViewController.h"

@interface ContactView : UIView

@property UITableView *tableView;

-(id) initWithController:(ContactViewController*)controller;

@end
