#import "BootstrapView.h"

@implementation BootstrapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
        label.text = @"请稍候";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

@end
