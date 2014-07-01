#import "ReportCustomView.h"

@implementation ReportCustomView

-(id) initWithController:(ReportCustomViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 468);
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

@end
