#import <UIKit/UIKit.h>

@interface LosCircleItem : NSObject

@property NSString *title;
@property double ratio;

-(id) initWithTitle:(NSString*)title Ratio:(double)ratio;

@end

@protocol LosCircleDelegate <NSObject>

-(int) itemCount;
-(LosCircleItem*) itemAtIndex:(int)index;
-(UIColor*) colorAtIndex:(int)index;

@end

@interface LosCircleChart : UIView

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosCircleDelegate>)delegate;

@end
