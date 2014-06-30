#import "Enterprise.h"

@implementation Enterprise

-(id) initWithId:(NSString*)pk Name:(NSString*)name
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.name = name;
    }
    return self;
}

@end
