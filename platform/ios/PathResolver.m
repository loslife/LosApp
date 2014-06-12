#import "PathResolver.h"

@implementation PathResolver

+(NSString*) documentsDirPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(NSString*) databaseFilePath
{
    NSString *documentsPath = [self documentsDirPath];
    
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    NSString *databaseFileDir = [documentsPath stringByAppendingPathComponent:userId];
    
    return [databaseFileDir stringByAppendingPathComponent:@"database.rdb"];
}

@end
