#import "ReportViewBase.h"

@protocol ReportServiceViewDataSource <NSObject>

@end

@interface ReportServiceView : ReportViewBase

-(id) initWithController:(id<ReportServiceViewDataSource>)controller;
-(void) reload;

@end
