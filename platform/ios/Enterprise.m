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

-(id) initWithId:(NSString*)pk Name:(NSString*)name state:(int)state
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.name = name;
        self.state = state;
    }
    return self;
}

@end
