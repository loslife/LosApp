#import "BusinessPerformance.h"

@implementation BusinessPerformance

-(id) initWithTitle:(NSString*)title Value:(double)value Ratio:(double)ratio
{
    self = [super init];
    if(self){
        self.title = title;
        self.value = value;
        self.ratio = ratio;
    }
    return self;
}

@end
