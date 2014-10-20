#import "NoShopView.h"
#import "LosStyles.h"

@implementation NoShopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
        label.center = CGPointMake(160, screenHeight / 2);
        label.text = @"您尚未关联店铺，请先到设置页面关联";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = GRAY4;
        label.font = [UIFont systemFontOfSize:14];

        [self addSubview:label];
    }
    return self;
}

@end
