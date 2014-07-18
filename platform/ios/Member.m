#import "Member.h"

@implementation Member

-(id) initWithPk:(NSString*)pk Name:(NSString*)name Birthday:(NSNumber*)birthday Phone:(NSString*)phone JoinDate:(NSNumber*)joinDate MemberNo:(NSString*)memberNo LatestConsume:(NSNumber*)latestConsume TotalConsume:(NSNumber*)total AverageConsume:(NSNumber*)average cardStr:(NSString*)cardStr desc:(NSString*)desc
{
    self = [super init];
    if(self){
        self.pk = pk;
        self.name= name;
        self.birthday = birthday;
        self.phoneMobile = phone;
        self.joinDate = joinDate;
        self.memberNo = memberNo;
        self.latestConsumeTime = latestConsume;
        self.totalConsume = total;
        self.averageConsume = average;
        self.cardStr = cardStr;
        self.consumeDesc = desc;
    }
    return self;
}

@end
