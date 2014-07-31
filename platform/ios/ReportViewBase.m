#import "ReportViewBase.h"

@implementation ReportViewBase

-(void) reload
{
    [self setNeedsDisplay];
}

-(void) refreshButtonDidPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_report_event" object:self];
}

@end
