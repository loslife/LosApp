#import <Foundation/Foundation.h>

@interface SyncService : NSObject

-(void) refreshAttachEnterprisesUserId:(NSString*)userId Block:(void(^)(BOOL flag))block;
-(void) refreshMembersWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block;

-(void) addEnterprise:(NSString*)userId EnterpriseAccount:(NSString*)phone Block:(void(^)(NSString* enterpriseId))block;
-(void) undoAttachWithAccount:(NSString*)account enterpriseId:(NSString*)enterpriseId block:(void(^)(BOOL flag))block;
-(void) reAttachWithAccount:(NSString*)account enterpriseAccount:(NSString*)enterpriseAccount block:(void(^)(BOOL flag))block;

@end
