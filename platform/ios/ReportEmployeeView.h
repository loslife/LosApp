#import <UIKit/UIKit.h>
#import "LosBarChart.h"
#import "ReportViewBase.h"

@protocol ReportEmployeeViewDataSource <NSObject>

-(BOOL) hasData;
-(double) totalNumber;

@end

@interface ReportEmployeeView : ReportViewBase

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportEmployeeViewDataSource, LosBarChartDataSource>)ds;

@end
