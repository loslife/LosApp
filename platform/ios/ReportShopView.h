#import "ReportViewBase.h"
#import "ReportShopViewController.h"
#import "LosPieChart.h"

@interface ReportShopView : ReportViewBase

-(id) initWithController:(ReportShopViewController*)controller;
-(void) reload;

@end
