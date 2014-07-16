#import <Foundation/Foundation.h>
#import "ContactViewController.h"

@interface ContactDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property BOOL membersInitDone;
@property NSMutableArray *members;

-(id) initWithController:(ContactViewController*)viewController;

@end
