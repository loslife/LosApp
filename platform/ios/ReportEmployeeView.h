#import <UIKit/UIKit.h>
#import "LosBarChart.h"

@protocol ReportEmployeeViewDataSource <NSObject>

-(BOOL) hasData;
-(int) totalNumber;

@end

@interface ReportEmployeeView : UIView

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportEmployeeViewDataSource, LosBarChartDataSource>)ds;
-(void) reload;

@end
