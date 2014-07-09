#import "ReportServiceView.h"

@implementation ReportServiceView

{
    id<ReportServiceViewDataSource> dataSource;
}

-(id) initWithController:(id<ReportServiceViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if (self) {
        
        dataSource = controller;
        
        UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        placeholder.text = @"产品业绩";
        placeholder.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:placeholder];
    }
    return self;
}

-(void) reload
{
    
}

@end
