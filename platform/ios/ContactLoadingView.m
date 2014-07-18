#import "ContactLoadingView.h"
#import "LosStyles.h"

@implementation ContactLoadingView

{
    UIActivityIndicatorView *indicator;
    UILabel *message;
}

- (id)init
{
    self = [super init];
    if(self){
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(160, 230)];
        [indicator startAnimating];
        
        message = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 280, 40)];
        message.text = @"正在努力为您加载，请耐心等候";
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = GRAY4;
        
        [self addSubview:indicator];
        [self addSubview:message];
    }
    return self;
}

-(void) showMemberCount:(int)count;
{
    message.text = [NSString stringWithFormat:@"本店共有%d个会员，正在努力为您加载，请耐心等候", count];
    message.numberOfLines = 2;
}

@end
