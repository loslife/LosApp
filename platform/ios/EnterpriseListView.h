#import <UIKit/UIKit.h>
#import "Enterprise.h"

@protocol EnterpriseListViewDelegate <NSObject>

-(NSUInteger) count;
-(Enterprise*) itemAtIndex:(int)index;

@end

@interface EnterpriseListView : UIView

-(id) initWithFrame:(CGRect)frame Delegate:(id<EnterpriseListViewDelegate>)delegate;
-(void) reload;

@end
