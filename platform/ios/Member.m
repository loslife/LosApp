#import "Member.h"

@implementation Member

-(id) initWithPk:(NSString*)pk Name:(NSString*)name Birthday:(NSNumber*)birthday Phone:(NSString*)phone JoinDate:(NSNumber*)joinDate MemberNo:(NSString*)memberNo
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.name= name;
        self.birthday = birthday;
        self.phoneMoble = phone;
        self.joinDate = joinDate;
        self.memberNo = memberNo;
    }
    return self;
}

@end
