#import <Foundation/Foundation.h>

@interface SyncService : NSObject

-(void) addEnterprise:(NSString*)userId EnterpriseAccount:(NSString*)phone Block:(void(^)(int flag))block;
-(void) refreshAttachEnterprisesUserId:(NSString*)userId Block:(void(^)(BOOL flag))block;
-(void) refreshMembersWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block;
-(void) refreshReportsWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block;

@end
