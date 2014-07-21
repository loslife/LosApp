#import "LosLineChart.h"
#import "ReportViewProtocol.h"

@protocol ReportCustomerViewDataSource <NSObject>

-(BOOL) hasData;
-(NSUInteger) memberCount;
-(NSUInteger) walkinCount;

@end

@interface ReportCustomView : UIView<ReportViewProtocol>

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportCustomerViewDataSource, LosLineChartDataSource>)ds;

@end
