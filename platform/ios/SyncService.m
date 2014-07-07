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

-(void) addEnterprise:(NSString*)userId EnterpriseAccount:(NSString*)phone Block:(void(^)(int flag))block
{
    NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_account=%@", userId, phone];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [httpHelper postSecure:APPEND_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
        
        if(dict == nil){
            block(1);
            return;
        }
        
        NSNumber *code = [dict objectForKey:@"code"];
        if([code intValue] != 0){
            block(2);
        }
        
        NSDictionary *result = [dict objectForKey:@"result"];
        NSString *enterpriseId = [result objectForKey:@"enterprise_id"];
        NSString *enterpriseName = [result objectForKey:@"enterprise_name"];
        
        [enterpriseDao insertEnterprisesWith:enterpriseId Name:enterpriseName];
        
        [self refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:[NSNumber numberWithInt:0] Block:^(BOOL flag){
            block(0);
        }];
    }];
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
        
        block(YES);
    }];
}

@end
