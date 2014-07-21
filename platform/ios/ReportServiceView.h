#import "ServicePerformance.h"
#import "LosPieChart.h"

@protocol ReportServiceViewDataSource <NSObject>

-(BOOL) hasData;
-(NSString*) total;
-(NSUInteger) itemCount;
-(ServicePerformance*) itemAtIndex:(int)index;

@end

@interface ReportServiceView : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportServiceViewDataSource, LosPieChartDelegate>)ds;
-(void) reload;

@end
