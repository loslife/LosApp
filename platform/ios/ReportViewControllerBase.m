#import "ReportViewControllerBase.h"

@implementation ReportViewControllerBase

- (void) handleSwipeLeft
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void) handleSwipeRight
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
