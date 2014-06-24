#import "UserData.h"

@implementation UserData

+(UserData*) load
{
    UserData *userData = [[UserData alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"user_id"];
    
    userData.userId = userId;
    
    return userData;
}

+(void) writeUserId:(NSString*)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:@"user_id"];
    [userDefaults synchronize];
}

+(void) removeUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_id"];
    [userDefaults synchronize];
}

@end
