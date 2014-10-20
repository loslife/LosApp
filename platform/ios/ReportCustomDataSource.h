#import <Foundation/Foundation.h>
#import "ReportCustomView.h"
#import "LosLineChart.h"
#import "ReportDataSourceBase.h"

@interface ReportCustomDataSource : ReportDataSourceBase<ReportCustomerViewDataSource, LosLineChartDataSource>

@end
