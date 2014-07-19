#import <UIKit/UIKit.h>

@interface LosDropDownItem : NSObject

@property NSString* title;
@property NSString* value;
@property BOOL selected;

-(id) initWithTitle:(NSString*)title value:(NSString*)value selected:(BOOL)selected;

@end

@protocol LosDropDownDelegate <NSObject>

-(void) menuItemTapped:(NSString*)value;
-(NSUInteger) itemCount;
-(LosDropDownItem*) itemAtIndex:(NSUInteger)index;

@end

@interface LosDropDown : UIView

-(id) initWithFrame:(CGRect)frame delegate:(id<LosDropDownDelegate>)delegate;

@end


