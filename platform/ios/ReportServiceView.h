#import "ServicePerformance.h"
#import "LosPieChart.h"
#import "ReportViewProtocol.h"

@protocol ReportServiceViewDataSource <NSObject>

-(BOOL) hasData;
-(NSString*) total;
-(NSUInteger) itemCount;
-(ServicePerformance*) itemAtIndex:(int)index;

@end

@interface ReportServiceView : UIView<ReportViewProtocol>

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportServiceViewDataSource, LosPieChartDelegate>)ds;

@end
