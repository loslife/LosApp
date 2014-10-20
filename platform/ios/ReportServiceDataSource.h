#import <Foundation/Foundation.h>
#import "ReportServiceView.h"
#import "LosPieChart.h"
#import "ReportDataSourceBase.h"

@interface ReportServiceDataSource : ReportDataSourceBase<ReportServiceViewDataSource, LosPieChartDelegate>

@end
