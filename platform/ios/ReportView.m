#import "ReportView.h"

@implementation ReportView

-(id) initWithController:(ReportViewController*)controller
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        
        NSDate *now = [NSDate date];
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 60, 320, 40) Delegate:controller InitDate:now type:DateDisplayTypeDay];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 468);
        label.text = @"报表View";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor redColor];
        
        [self addSubview:dateSelectionBar];
        [self addSubview:label];
    }
    return self;
}

- (void) handleSwipeLeft
{
    NSLog(@"swipe left");
}

- (void) handleSwipeRight
{
    NSLog(@"swipe right");
}

@end
