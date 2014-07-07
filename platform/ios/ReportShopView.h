#import "ReportViewBase.h"
#import "LosPieChart.h"

@protocol ReportShopViewDataSource <NSObject>

-(NSString*) total;

@end

@interface ReportShopView : ReportViewBase

-(id) initWithController:(id<ReportShopViewDataSource>)controller;
-(void) reload;

@end
