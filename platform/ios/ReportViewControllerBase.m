#import "ReportViewControllerBase.h"
#import "ReportDateStatus.h"

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
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    [status setDate:date];
    [status setDateType:type];
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
