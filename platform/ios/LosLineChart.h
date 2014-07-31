#import <UIKit/UIKit.h>

@interface LosLineChartItem : NSObject

@property int value;
@property NSString* yAxisTitle;
@property int order;

-(id) initWithTitle:(NSString*)yAxisTitle value:(int)value order:(int)order;

@end

@protocol LosLineChartDataSource <NSObject>

-(NSUInteger) valuePerSection;
-(NSUInteger) itemCount;
-(LosLineChartItem*) itemAtIndex:(int)index;

@end

@interface LosLineChart : UIView

-(id) initWithFrame:(CGRect)frame dataSource:(id<LosLineChartDataSource>)ds;

@end
