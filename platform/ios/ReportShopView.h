#import "LosPieChart.h"
#import "BusinessPerformance.h"
#import "ReportViewBase.h"

@protocol ReportShopViewDataSource <NSObject>

-(BOOL) hasData;
-(NSString*) total;
-(NSUInteger) itemCount;
-(BusinessPerformance*) itemAtIndex:(int)index;

@end

@interface ReportShopView : ReportViewBase

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportShopViewDataSource, LosPieChartDelegate>)ds;

@end
