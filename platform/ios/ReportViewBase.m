#import "ReportViewBase.h"

@implementation ReportViewBase

-(id) initWithController:(ReportViewControllerBase*)controller;
{
    self = [super init];
    if (self) {
        
        NSDate *now = [NSDate date];
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 60, 320, 40) Delegate:controller InitDate:now type:DateDisplayTypeDay];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:controller action:@selector(handleSwipeLeft)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:controller action:@selector(handleSwipeRight)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addSubview:dateSelectionBar];
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

@end
