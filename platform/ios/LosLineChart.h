#import <UIKit/UIKit.h>

@protocol LosLineChartDataSource <NSObject>

-(NSUInteger) valuePerSection;

@end

@interface LosLineChart : UIView

-(id) initWithFrame:(CGRect)frame dataSource:(id<LosLineChartDataSource>)ds;

@end
