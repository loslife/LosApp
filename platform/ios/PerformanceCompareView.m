#import "PerformanceCompareView.h"

@implementation PerformanceCompareView

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title CompareText:(NSString*)text Value:(NSString*)value Increase:(BOOL)increase
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat maxY = frame.size.height;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, maxY)];
        UIImage *arrow;
        if(increase){
            arrow = [UIImage imageNamed:@"arrow_up"];
        }else{
            arrow = [UIImage imageNamed:@"arrow_down"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:arrow];
        imageView.frame = CGRectMake(15, 5, 10, 10);
        [leftView addSubview:imageView];
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 180, maxY)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, maxY / 2)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *compareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY / 2, 180, maxY / 2)];
        compareLabel.text = text;
        compareLabel.textAlignment = NSTextAlignmentLeft;
        compareLabel.font = [UIFont systemFontOfSize:14.0];
        compareLabel.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        [middleView addSubview:titleLabel];
        [middleView addSubview:compareLabel];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(220, 0, 80, maxY)];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, maxY / 2)];
        valueLabel.text = value;
        valueLabel.textAlignment = NSTextAlignmentRight;
        if(increase){
            valueLabel.textColor = [UIColor colorWithRed:227/255.0f green:110/255.0f blue:66/255.0f alpha:1.0f];
        }else{
            valueLabel.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        }
        
        [rightView addSubview:valueLabel];
        
        [self addSubview:leftView];
        [self addSubview:middleView];
        [self addSubview:rightView];
    }
    return self;
}

@end
