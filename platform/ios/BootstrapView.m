#import "BootstrapView.h"

@implementation BootstrapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        label.text = @"数据加载中，请稍候";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

@end
