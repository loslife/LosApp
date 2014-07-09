#import "ReportViewBase.h"
#import "ServicePerformance.h"

@protocol ReportServiceViewDataSource <NSObject>

-(NSString*) total;
-(NSUInteger) itemCount;
-(ServicePerformance*) itemAtIndex:(int)index;

@end

@interface ReportServiceView : ReportViewBase

-(id) initWithController:(id<ReportServiceViewDataSource>)controller;
-(void) reload;

@end
