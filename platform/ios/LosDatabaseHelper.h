#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface LosDatabaseHelper : NSObject

+(LosDatabaseHelper*) sharedInstance;
+(void) refreshDatabaseFile;

-(void) inDatabase:(void(^)(FMDatabase*))block;

@end
