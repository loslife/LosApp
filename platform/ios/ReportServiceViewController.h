#import "ReportViewControllerBase.h"
#import "ReportServiceView.h"
#import "LosPieChart.h"

@interface ReportServiceViewController : ReportViewControllerBase<LosPieChartDelegate, ReportServiceViewDataSource>

@end
