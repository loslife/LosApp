#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,copy) NSString *pk;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSNumber *birthday;
@property(nonatomic,copy) NSString *phoneMobile;
@property(nonatomic,copy) NSNumber *joinDate;
@property(nonatomic,copy) NSString *memberNo;
@property(nonatomic,copy) NSNumber *latestConsumeTime;
@property(nonatomic,copy) NSNumber *totalConsume;
@property(nonatomic,copy) NSNumber *averageConsume;
@property(nonatomic,copy) NSString *cardStr;
@property(nonatomic,copy) NSString *consumeDesc;
@property(nonatomic,copy) NSNumber *sex;

@property NSInteger sectionNumber;

+(Member*) memberWithPk:(NSString*)pk Name:(NSString*)name Birthday:(NSNumber*)birthday Phone:(NSString*)phone JoinDate:(NSNumber*)joinDate MemberNo:(NSString*)memberNo LatestConsume:(NSNumber*)latestConsume TotalConsume:(NSNumber*)total AverageConsume:(NSNumber*)average cardStr:(NSString*)cardStr desc:(NSString*)desc sex:(NSNumber*)sex sectionNumber:(NSInteger)sectionNumber;

+(Member*) memberWithName:(NSString*)name;

@end
