#import "ReportViewBase.h"
#import "ReportDateStatus.h"

@implementation ReportViewBase

-(id) initWithController:(ReportViewControllerBase*)controller;
{
    self = [super init];
    if (self) {
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 60, 320, 40) Delegate:controller InitDate:[status date] type:[status dateType]];
        
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
