#import <UIKit/UIKit.h>

@protocol InteractiveViewDelegate <NSObject>

-(void) close;

@end

@interface InteractiveView : UIView

-(id) initWithDelegate:(id<InteractiveViewDelegate>)delegate;

@end
