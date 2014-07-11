#import "CustomerCount.h"

@implementation CustomerCount

-(id) initWithTotalMember:(int)member walkin:(int)walkin count:(int)count title:(NSString*)title
{
    self = [super init];
    if(self){
        self.totalMember = member;
        self.totalWalkin = walkin;
        self.count = count;
        self.title = title;
    }
    return self;
}

@end
