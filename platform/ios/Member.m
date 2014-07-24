#import "Member.h"

@implementation Member

+(Member*) memberWithPk:(NSString*)pk Name:(NSString*)name Birthday:(NSNumber*)birthday Phone:(NSString*)phone JoinDate:(NSNumber*)joinDate MemberNo:(NSString*)memberNo LatestConsume:(NSNumber*)latestConsume TotalConsume:(NSNumber*)total AverageConsume:(NSNumber*)average cardStr:(NSString*)cardStr desc:(NSString*)desc sex:(NSNumber*)sex sectionNumber:(NSInteger)sectionNumber
{
    Member *instance = [[Member alloc] init];
    
    instance.pk = pk;
    instance.name= name;
    instance.birthday = birthday;
    instance.phoneMobile = phone;
    instance.joinDate = joinDate;
    instance.memberNo = memberNo;
    instance.latestConsumeTime = latestConsume;
    instance.totalConsume = total;
    instance.averageConsume = average;
    instance.cardStr = cardStr;
    instance.consumeDesc = desc;
    instance.sex = sex;
    instance.sectionNumber = sectionNumber;
    
    return instance;
}

+(Member*) memberWithName:(NSString*)name
{
    Member *instance = [[Member alloc] init];
    instance.name = name;
    return instance;
}

@end
