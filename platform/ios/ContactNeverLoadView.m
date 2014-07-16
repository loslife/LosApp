#import "ContactNeverLoadView.h"

@implementation ContactNeverLoadView

-(id) initWithController:(ContactViewController*)controller;
{
    self = [super init];
    if(self){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        label.text = @"点击加载会员";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
    }
    return self;
}

@end
