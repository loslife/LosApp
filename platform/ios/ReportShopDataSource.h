#import <Foundation/Foundation.h>
#import "ReportShopView.h"
#import "LosPieChart.h"
#import "ReportDataSourceBase.h"

@interface ReportShopDataSource : ReportDataSourceBase<ReportShopViewDataSource, LosPieChartDelegate>

@end
