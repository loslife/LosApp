#import "ReportViewBase.h"
#import "LosPieChart.h"
#import "BusinessPerformance.h"

@protocol ReportShopViewDataSource <NSObject>

-(NSString*) total;
-(NSUInteger) itemCount;
-(BusinessPerformance*) itemAtIndex:(int)index;

@end

@interface ReportShopView : ReportViewBase

-(id) initWithController:(id<ReportShopViewDataSource>)controller;
-(void) reload;

@end
