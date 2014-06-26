#import <Foundation/Foundation.h>
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"

@interface SyncService : NSObject

-(void) addEnterprise:(NSString*)enterpriseId Name:(NSString*)enterpriseName;
-(void) refreshAttachEnterprises:(NSArray*)enterprises;
-(void) refreshMembersWithRecords:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId;

@end
