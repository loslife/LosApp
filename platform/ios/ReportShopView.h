#import "ReportViewBase.h"
#import "ReportShopViewController.h"
#import "LosPieChart.h"

@interface ReportShopView : ReportViewBase<LosPieChartDelegate>

-(id) initWithController:(ReportShopViewController*)controller;

@end
