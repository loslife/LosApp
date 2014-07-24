#import <UIKit/UIKit.h>
#import "Enterprise.h"

@protocol EnterpriseListViewDelegate <NSObject>

-(void) reAttach:(NSString*)enterpriseId;
-(void) undoAttach:(NSString*)enterpriseId;

@end

@interface EnterpriseListView : UIScrollView

-(id) initWithFrame:(CGRect)frame Delegate:(id<EnterpriseListViewDelegate>)delegate;
-(void) reload;

@end
