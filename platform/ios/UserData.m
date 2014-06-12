#import "UserData.h"

@implementation UserData

+(UserData*) load
{
    UserData *userData = [[UserData alloc] init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"user_id"];
    NSString *enterpriseId = [userDefaults objectForKey:@"enterprise_id"];
    
    userData.userId = userId;
    userData.enterpriseId = enterpriseId;
    
    return userData;
}

+(void) writeUserId:(NSString*)userId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userId forKey:@"user_id"];
    [userDefaults synchronize];
}

@end
