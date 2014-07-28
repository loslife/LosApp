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
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 80)];
        image1.center = CGPointMake(160, screenHeight / 2 - 80);
        image1.image = [UIImage imageNamed:@"gesture_switch"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label1.center = CGPointMake(160, screenHeight / 2 - 20);
        label1.text = @"1. 左右滑动，切换其他业绩";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        
        UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
        image2.center = CGPointMake(160, screenHeight / 2 + 60);
        image2.image = [UIImage imageNamed:@"gesture_refresh"];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label2.center = CGPointMake(160, screenHeight / 2 + 120);
        label2.text = @"2. 连续触摸屏幕2次，刷新业绩";
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = [UIColor whiteColor];
        
        UIButton *iknow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        iknow.frame = CGRectMake(120, screenHeight - 89, 80, 40);
        [iknow setTitle:@"我知道了" forState:UIControlStateNormal];
        iknow.tintColor = BLUE1;
        [iknow addTarget:delegate action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:image1];
        [self addSubview:label1];
        [self addSubview:image2];
        [self addSubview:label2];
        [self addSubview:iknow];
    }
    return self;
}

@end
