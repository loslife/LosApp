#import "ReportViewBase.h"

@protocol ReportCustomerViewDataSource <NSObject>

-(NSUInteger) memberCount;
-(NSUInteger) walkinCount;

@end

@interface ReportCustomView : ReportViewBase

-(id) initWithController:(id<ReportCustomerViewDataSource>)controller;
-(void) reload;

@end
