#import "ReportViewBase.h"
#import "ReportDateStatus.h"

@implementation ReportViewBase

{
    UIViewController *myController;
}

-(id) initWithController:(ReportViewControllerBase*)controller;
{
    self = [super init];
    if (self) {
        
        myController = controller;
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 60, 320, 40) Delegate:controller InitDate:[status date] type:[status dateType]];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:controller action:@selector(handleSwipeLeft)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:controller action:@selector(handleSwipeRight)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        
        [self addSubview:dateSelectionBar];
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void) handleTap
{
    SwitchShopButton* barButton = (SwitchShopButton*)myController.navigationItem.rightBarButtonItem;
    [barButton closeSwitchShopMenu];
}

@end
