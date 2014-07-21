#import "LosPieChart.h"
#import "BusinessPerformance.h"

@protocol ReportShopViewDataSource <NSObject>

-(BOOL) hasData;
-(NSString*) total;
-(NSUInteger) itemCount;
-(BusinessPerformance*) itemAtIndex:(int)index;

@end

@interface ReportShopView : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportShopViewDataSource, LosPieChartDelegate>)ds;
-(void) reload;

@end
