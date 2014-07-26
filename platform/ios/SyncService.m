#import "SyncService.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"
#import "LosDao.h"

@implementation SyncService

{
    LosHttpHelper *httpHelper;
    EnterpriseDao *enterpriseDao;
    MemberDao *memberDao;
}

-(id) init
{
    self = [super init];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
        enterpriseDao = [[EnterpriseDao alloc] init];
        memberDao = [[MemberDao alloc] init];
    }
    return self;
}

-(void) refreshAttachEnterprisesUserId:(NSString*)userId Block:(void(^)(BOOL flag))block
{
    NSString *url = [NSString stringWithFormat:FETCH_ENTERPRISES_URL, userId];
    
    [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
        
        if(dict == nil){
            block(NO);
            return;
        }
        
        NSNumber *code = [dict objectForKey:@"code"];
        if([code intValue] != 0){
            block(NO);
            return;
        }
        
        NSDictionary *result = [dict objectForKey:@"result"];
        NSArray *enterprises = [result objectForKey:@"myShopList"];
        [enterpriseDao batchInsertEnterprises:enterprises];
        
        block(YES);
    }];
}

-(void) refreshMembersWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block
{
    NSString *url = [NSString stringWithFormat:SYNC_MEMBERS_URL, enterpriseId, @"1", [latestSyncTime stringValue]];
    
    [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
        
        if(dict == nil){
            block(NO);
            return;
        }
        
        NSNumber *code = [dict objectForKey:@"code"];
        if([code intValue] != 0){
            block(NO);
            return;
        }
        
        NSDictionary *response = [dict objectForKey:@"result"];
        NSNumber *lastSync = [response objectForKey:@"last_sync"];
        NSDictionary *records = [response objectForKey:@"records"];
        
        [memberDao batchUpdateMembers:records LastSync:lastSync EnterpriseId:enterpriseId];
        [enterpriseDao updateSyncFlagById:enterpriseId];
        
        block(YES);
    }];
}

@end
