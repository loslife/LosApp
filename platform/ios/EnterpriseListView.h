#import <UIKit/UIKit.h>
#import "Enterprise.h"

@protocol EnterpriseListViewDelegate <NSObject>

-(void) reAttach:(NSString*)enterpriseId name:(NSString*)enterpriseName;
-(void) undoAttach:(NSString*)enterpriseId name:(NSString*)enterpriseName;

@end

@interface EnterpriseListView : UIScrollView

-(id) initWithFrame:(CGRect)frame Delegate:(id<EnterpriseListViewDelegate>)delegate;
-(void) reload;

@end
