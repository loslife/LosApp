#import "ReportLoadingView.h"
#import "LosStyles.h"
#import "LosTimePicker.h"
#import "ReportDateStatus.h"

@implementation ReportLoadingView

{
    UIActivityIndicatorView *indicator;
}

-(id) init
{
    self = [super init];
    if(self){
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 64, 320, 40) Delegate:nil InitDate:[status date] type:[status dateType]];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(160, 208)];
        [indicator startAnimating];
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 280, 40)];
        message.text = @"正在加载报表数据，请稍候";
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = GRAY4;
        
        [self addSubview:dateSelectionBar];
        [self addSubview:indicator];
        [self addSubview:message];
    }
    return self;
}

@end
