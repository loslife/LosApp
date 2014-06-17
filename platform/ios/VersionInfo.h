#import <Foundation/Foundation.h>
#import "PathResolver.h"
#import "FMDB.h"

@interface VersionInfo : NSObject

-(BOOL) needInit;
-(NSString*) oldVersion;
-(NSString*) currentVersion;

@end
