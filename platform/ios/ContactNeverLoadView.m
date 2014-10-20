#import "ContactNeverLoadView.h"
#import "LosStyles.h"

@implementation ContactNeverLoadView

-(id) initWithController:(ContactViewController*)controller;
{
    self = [super init];
    if(self){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(100, 250, 120, 40);
        [button setTitle:@"点击加载会员" forState:UIControlStateNormal];
        [button addTarget:controller action:@selector(loadMembersFromServer) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textColor = BLUE1;
        
        [self addSubview:button];
    }
    return self;
}

@end
