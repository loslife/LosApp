#import "ReportViewBase.h"

@protocol ReportCustomerViewDataSource <NSObject>

@end

@interface ReportCustomView : ReportViewBase

-(id) initWithController:(id<ReportCustomerViewDataSource>)controller;

@end
