#import <UIKit/UIKit.h>
#import "LosBarChart.h"
#import "ReportViewProtocol.h"

@protocol ReportEmployeeViewDataSource <NSObject>

-(BOOL) hasData;
-(double) totalNumber;

@end

@interface ReportEmployeeView : UIView<ReportViewProtocol>

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportEmployeeViewDataSource, LosBarChartDataSource>)ds;

@end
