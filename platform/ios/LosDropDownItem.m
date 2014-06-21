#import "LosDropDown.h"

@implementation LosDropDownItem

-(id) initWithTitle:(NSString*)title value:(NSString*)value
{
    self = [super init];
    if(self){
        self.title = title;
        self.value = value;
    }
    return self;
}

@end
