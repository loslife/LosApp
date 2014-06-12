#import <Foundation/Foundation.h>
#import "UserData.h"

@interface PathResolver : NSObject

+(NSString*) documentsDirPath;
+(NSString*) databaseFilePath;

@end
