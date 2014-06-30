#import "ReportViewBase.h"

@implementation ReportViewBase

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
    }
    return self;
}

#pragma mark - abstract method

- (void) handleSwipeLeft
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) handleSwipeRight
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
