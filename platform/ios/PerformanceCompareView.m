#import "PerformanceCompareView.h"

@implementation PerformanceCompareView

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title CompareText:(NSString*)text Value:(NSString*)value
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat maxY = frame.size.height;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, maxY)];
        
        UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 180, maxY)];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, maxY / 2)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *compareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, maxY / 2, 180, maxY / 2)];
        compareLabel.text = text;
        compareLabel.textAlignment = NSTextAlignmentLeft;
        compareLabel.font = [UIFont systemFontOfSize:14.0];
        
        [middleView addSubview:titleLabel];
        [middleView addSubview:compareLabel];
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(220, 0, 80, maxY)];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, maxY / 2)];
        valueLabel.text = value;
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        [rightView addSubview:valueLabel];
        
        [self addSubview:leftView];
        [self addSubview:middleView];
        [self addSubview:rightView];
    }
    return self;
}

@end
