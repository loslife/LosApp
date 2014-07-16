#import <Foundation/Foundation.h>
#import "ContactViewController.h"

@interface ContactDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *members;

-(id) initWithController:(ContactViewController*)viewController;

@end
