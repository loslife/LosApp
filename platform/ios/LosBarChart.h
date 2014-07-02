#import <UIKit/UIKit.h>

@protocol LosBarChartDataSource <NSObject>

-(int) totalValue;
-(NSUInteger) rowCount;
-(int) maxValue;
-(NSString*) nameAtIndex:(int)index;
-(int) valueAtIndex:(int)index;

@end

@interface LosBarChart : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<LosBarChartDataSource>)ds;
-(void) reload;

@end
