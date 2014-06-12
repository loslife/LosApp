#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property NSString *userId;
@property NSString *enterpriseId;

+(UserData*) load;

@end
