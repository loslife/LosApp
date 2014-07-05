#import "ReportViewBase.h"
#import "ReportShopViewController.h"
#import "LosCircleChart.h"

@interface ReportShopView : ReportViewBase<LosCircleDelegate>

-(id) initWithController:(ReportShopViewController*)controller;

@end
