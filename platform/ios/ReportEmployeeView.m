#import "ReportEmployeeView.h"

@implementation ReportEmployeeView

-(id) initWithController:(ReportEmployeeViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
        
        self.barView = [[LosBarChart alloc] initWithFrame:CGRectMake(0, 100, 320, 468) DataSource:controller];
        [self addSubview:self.barView];
    }
    return self;
}

@end
