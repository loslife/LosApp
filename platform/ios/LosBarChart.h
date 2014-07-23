#import <UIKit/UIKit.h>

@protocol LosBarChartDataSource <NSObject>

-(NSUInteger) rowCount;
-(int) maxValue;
-(NSString*) nameAtIndex:(int)index;
-(double) valueAtIndex:(int)index;

@end

@interface LosBarChart : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<LosBarChartDataSource>)ds;

@end
