#import "LosLineChart.h"
#import "ReportViewBase.h"

@protocol ReportCustomerViewDataSource <NSObject>

-(BOOL) hasData;
-(NSUInteger) memberCount;
-(NSUInteger) walkinCount;

@end

@interface ReportCustomView : ReportViewBase

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportCustomerViewDataSource, LosLineChartDataSource>)ds;

@end
