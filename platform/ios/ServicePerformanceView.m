#import "ServicePerformanceView.h"

@implementation ServicePerformanceView

-(id) initWithFrame:(CGRect)frame title:(NSString*)title ratio:(NSString*)ratio value:(NSString*)value
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat maxY = frame.size.height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, maxY)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *ratioLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 60, maxY)];
        ratioLabel.text = ratio;
        ratioLabel.textAlignment = NSTextAlignmentLeft;
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, maxY)];
        valueLabel.text = value;
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:titleLabel];
        [self addSubview:ratioLabel];
        [self addSubview:valueLabel];
    }
    return self;
}

@end
