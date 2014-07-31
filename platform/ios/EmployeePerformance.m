#import "EmployeePerformance.h"

@implementation EmployeePerformance

-(id) initWithPk:(NSString*)pk Total:(NSNumber*)total Name:(NSString*)name
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.total = total;
        self.employeeName = name;
    }
    return self;
}

@end
