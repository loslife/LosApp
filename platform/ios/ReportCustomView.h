#import "LosLineChart.h"

@protocol ReportCustomerViewDataSource <NSObject>

-(BOOL) hasData;
-(NSUInteger) memberCount;
-(NSUInteger) walkinCount;

@end

@interface ReportCustomView : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportCustomerViewDataSource, LosLineChartDataSource>)ds;
-(void) reload;

@end
