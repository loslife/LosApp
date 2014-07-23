#import "NoShopView.h"
#import "LosStyles.h"

@implementation NoShopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 289, 280, 40)];
        label.text = @"您尚未关联店铺，请先到设置页面关联";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = GRAY4;
        label.font = [UIFont systemFontOfSize:14];

        [self addSubview:label];
    }
    return self;
}

@end
