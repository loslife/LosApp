#import <UIKit/UIKit.h>

@protocol LoginOrRegisterViewDelegate <NSObject>

-(void) registerButtonTapped;
-(void) loginButtonTapped;

@end

@interface LoginOrRegisterView : UIView

-(id) initWithDelegate:(id<LoginOrRegisterViewDelegate>)delegate;

@end
