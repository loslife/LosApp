#import "BootstrapView.h"

@implementation BootstrapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bootstrap"]];
    }
    return self;
}

@end
