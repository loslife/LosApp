#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property NSString *userId;

+(UserData*) load;
+(void) writeUserId:(NSString*)userId;

@end
