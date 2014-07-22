#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property NSString *userId;
@property NSString *enterpriseId;

+(UserData*) load;
+(void) writeUserId:(NSString*)userId;
+(void) writeCurrentEnterprise:(NSString*)enterpirseId;
+(void) removeCurrentEnterprise;
+(void) remove;

@end
