#import <UIKit/UIKit.h>

@protocol AppUpdateViewDelegate <NSObject>

-(void) update;
-(BOOL) hasNewVersion;
-(NSArray*) featuresDescription;

@end

@interface AppUpdateView : UIView

-(id) initWithController:(id<AppUpdateViewDelegate>)viewController;
-(void) reload;

@end
