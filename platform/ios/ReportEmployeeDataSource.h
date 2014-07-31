#import <Foundation/Foundation.h>
#import "LosBarChart.h"
#import "ReportEmployeeView.h"
#import "ReportDataSourceBase.h"

@interface ReportEmployeeDataSource : ReportDataSourceBase<ReportEmployeeViewDataSource, LosBarChartDataSource>

@end
