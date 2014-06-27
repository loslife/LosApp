#import "LosTimePicker.h"

@implementation LosTimePicker


-(id) initWithFrame:(CGRect)frame Delegate:(id<LosTimePickerDelegate>)delegate InitDate:(NSDate*)date type:(DateDisplayType)type
{
    self = [super initWithFrame:frame];
    if(self){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.text = @"test";
        
        self.backgroundColor = [UIColor grayColor];
        [self addSubview:label];
    }
    return self;
}

@end
