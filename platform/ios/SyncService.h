#import <Foundation/Foundation.h>

@interface SyncService : NSObject

-(void) refreshMembersWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block;

@end
