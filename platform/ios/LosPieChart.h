#import <UIKit/UIKit.h>

@interface LosPieChartItem : NSObject

@property NSString *title;
@property double ratio;

-(id) initWithTitle:(NSString*)title Ratio:(double)ratio;

@end

@protocol LosPieChartDelegate <NSObject>

-(NSUInteger) itemCount;
-(LosPieChartItem*) pieItemAtIndex:(int)index;
-(UIColor*) colorAtIndex:(int)index;

@end

@interface LosPieChart : UIView

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosPieChartDelegate>)delegate;

@end
