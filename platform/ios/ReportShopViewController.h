#import "ReportViewControllerBase.h"
#import "LosPieChart.h"
#import "ReportShopView.h"

@interface ReportShopViewController : ReportViewControllerBase<LosPieChartDelegate, ReportShopViewDataSource>

@end
