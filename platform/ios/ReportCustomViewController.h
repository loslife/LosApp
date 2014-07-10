#import <UIKit/UIKit.h>
#import "ReportViewControllerBase.h"
#import "ReportCustomView.h"
#import "LosLineChart.h"

@interface ReportCustomViewController : ReportViewControllerBase<ReportCustomerViewDataSource, LosLineChartDataSource>

@end
