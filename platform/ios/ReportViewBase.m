#import "ReportViewBase.h"
#import "MJRefresh.h"

@implementation ReportViewBase

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self addHeaderWithTarget:self action:@selector(sendRefreshNotification) dateKey:@"mjrefresh_date_report"];
    }
    return self;
}

-(void) reload
{
    [self setNeedsDisplay];
}

-(void) sendRefreshNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_report_event" object:self];
}

@end
