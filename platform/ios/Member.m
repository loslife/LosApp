#import "Member.h"

@implementation Member

-(id) initWithPk:(NSString*)pk Name:(NSString*)name
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.name= name;
    }
    return self;
}

@end
