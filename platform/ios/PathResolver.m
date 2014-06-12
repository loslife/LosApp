#import "PathResolver.h"

@implementation PathResolver

+(NSString*) documentsDirPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(NSString*) currentUserDirPath
{
    NSString *documentsPath = [self documentsDirPath];
    
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    return [documentsPath stringByAppendingPathComponent:userId];
}

+(NSString*) databaseFilePath
{
    NSString *currentUserDir = [self currentUserDirPath];
    return [currentUserDir stringByAppendingPathComponent:@"database.rdb"];
}

@end
