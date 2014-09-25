#import "ReportViewBase.h"
#import "MJRefresh.h"

@implementation ReportViewBase

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addHeaderWithTarget:self action:@selector(sendRefreshNotification)];
    }
    return self;
}

-(void) reload
{
    [self setNeedsDisplay];
}

-(void) refreshButtonDidPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_report_event" object:self];
}

-(void) sendRefreshNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_report_event" object:self];
}

@end
