#import "LosTextField.h"

@implementation LosTextField

-(id)initWithFrame:(CGRect)frame Icon:(NSString*)iconName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat height = frame.size.height;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, height - 1, height - 2)];
        leftView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        icon.frame = CGRectMake(height / 4, height / 4, height / 2, height / 2);
        [leftView addSubview:icon];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:leftView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = leftView.bounds;
        maskLayer.path = maskPath.CGPath;
        leftView.layer.mask = maskLayer;
        
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 1;
    return iconRect;
}

@end
