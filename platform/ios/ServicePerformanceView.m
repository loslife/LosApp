#import "ServicePerformanceView.h"
#import "LosStyles.h"

@implementation ServicePerformanceView

-(id) initWithFrame:(CGRect)frame title:(NSString*)title ratio:(NSString*)ratio value:(NSString*)value
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat maxY = frame.size.height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, maxY)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *ratioLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 60, maxY)];
        ratioLabel.text = ratio;
        ratioLabel.textAlignment = NSTextAlignmentLeft;
        ratioLabel.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, maxY)];
        valueLabel.text = value;
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = BLUE1;
        
        [self addSubview:titleLabel];
        [self addSubview:ratioLabel];
        [self addSubview:valueLabel];
    }
    return self;
}

@end
