#import "ReportEmployeeView.h"

@implementation ReportEmployeeView

-(id) initWithController:(ReportEmployeeViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 468);
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

@end
