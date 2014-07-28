#import "ServicePerformance.h"
#import "LosPieChart.h"
#import "ReportViewBase.h"

@protocol ReportServiceViewDataSource <NSObject>

-(BOOL) hasData;
-(NSString*) total;
-(NSUInteger) itemCount;
-(ServicePerformance*) itemAtIndex:(int)index;

@end

@interface ReportServiceView : ReportViewBase

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportServiceViewDataSource, LosPieChartDelegate>)ds;

@end
