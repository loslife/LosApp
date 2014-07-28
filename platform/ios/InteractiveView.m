#import "InteractiveView.h"
#import "UserData.h"
#import "LosStyles.h"

@implementation InteractiveView

-(id) initWithDelegate:(id<InteractiveViewDelegate>)delegate;
{
    self = [super init];
    if (self) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, 320, screenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 80)];
        image.center = CGPointMake(160, screenHeight - 49);
        image.image = [UIImage imageNamed:@"gesture_switch"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.center = CGPointMake(160, 210);
        label.text = @"左右滑动，切换业绩";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        UIButton *iknow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        iknow.frame = CGRectMake(120, 240, 80, 40);
        [iknow setTitle:@"我知道了" forState:UIControlStateNormal];
        iknow.tintColor = BLUE1;
        iknow.titleLabel.font = [UIFont systemFontOfSize:18];
        [iknow addTarget:delegate action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:image];
        [self addSubview:label];
        [self addSubview:iknow];
    }
    return self;
}

@end
