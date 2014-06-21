#import <UIKit/UIKit.h>

@protocol LosDropDownDelegate <NSObject>

-(void) menuItemTapped:(NSString*)value;

@end

@interface LosDropDown : UITableView<UITableViewDelegate,UITableViewDataSource>

-(id) initWithFrame:(CGRect)frame MenuItems:(NSArray*)source Delegate:(id<LosDropDownDelegate>)delegate;

@end

@interface LosDropDownItem : NSObject

@property NSString* title;
@property NSString* value;

-(id) initWithTitle:(NSString*)title value:(NSString*)value;

@end
