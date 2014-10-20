#import "AppUpdateView.h"
#import "LosStyles.h"

@implementation AppUpdateView

{
    id<AppUpdateViewDelegate> controller;
    
    UIView *header;
    UIView *features;
    
    UILabel *message;
    UIButton *button;
    
    UIActivityIndicatorView *indicator;
}

-(id) initWithController:(id<AppUpdateViewDelegate>)viewController
{
    self = [super init];
    if(self){
        
        controller = viewController;
        
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 100)];
        
        UILabel *checking = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
        checking.text = @"正在检测新版本";
        checking.textAlignment = NSTextAlignmentCenter;
        checking.font = [UIFont systemFontOfSize:14];
        checking.textColor = GRAY4;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(160, 70)];
        [indicator startAnimating];
        
        [header addSubview:checking];
        [header addSubview:indicator];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 10)];
        bar.backgroundColor = GRAY1;
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, 280, 40)];
        desc.text = @"新版介绍";
        desc.textAlignment = NSTextAlignmentLeft;
        
        features = [[UIView alloc] initWithFrame:CGRectMake(20, 220, 280, 200)];
        
        [self addSubview:header];
        [self addSubview:bar];
        [self addSubview:desc];
        [self addSubview:features];
        
        message = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = GRAY4;

        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 50, 280, 40);
        [button setTitle:@"立即更新" forState:UIControlStateNormal];
        button.backgroundColor = RED1;
        button.tintColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5;
        [button addTarget:controller action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) reload
{
    [indicator stopAnimating];
    
    for(UIView* subview in header.subviews){
        [subview removeFromSuperview];
    }
    
    if(![controller checkDone]){
        message.text = @"您的网络异常，请检查网络后重试";
        button.enabled = NO;
    }else if(![controller hasNewVersion]){
        message.text = @"当前已经是最新版本";
        button.enabled = NO;
    }else{
        message.text = [NSString stringWithFormat:@"已检测到新版本：%@", [controller newVersionCode]];
        button.enabled = YES;
    }
    
    [header addSubview:message];
    [header addSubview:button];
    
    NSArray *descs = [controller featuresDescription];
    
    NSUInteger count = [descs count];
    
    for(int i=0; i < count; i++){
        
        NSString *desc = [descs objectAtIndex:i];
        
        UILabel *feature = [[UILabel alloc] initWithFrame:CGRectMake(0, 20 * i, 280, 20)];
        feature.text = [NSString stringWithFormat:@"%d. %@", i + 1, desc];
        feature.textAlignment = NSTextAlignmentLeft;
        feature.textColor = GRAY4;
        feature.font = [UIFont systemFontOfSize:14];
        
        [features addSubview:feature];
    }
}

@end
