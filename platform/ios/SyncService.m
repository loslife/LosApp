#import "SyncService.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"
#import "LosDao.h"

@implementation SyncService

{
    LosHttpHelper *httpHelper;
    LosDao *dao;
}

-(id) init
{
    self = [super init];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
        dao = [[LosDao alloc] init];
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
        
        [dao insertEnterprisesWith:enterpriseId Name:enterpriseName];
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [self refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:[NSNumber numberWithInt:0] Block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self refreshReportsWithEnterpriseId:enterpriseId LatestSyncTime:[NSNumber numberWithInt:0] Block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
            block(0);
        });
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
        [dao batchInsertEnterprises:enterprises];
        
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
        
        [dao batchUpdateMembers:records LastSync:lastSync EnterpriseId:enterpriseId];
        
        block(YES);
    }];
}

-(void) refreshReportsWithEnterpriseId:(NSString*)enterpriseId LatestSyncTime:(NSNumber*)latestSyncTime Block:(void(^)(BOOL flag))block
{
    NSString *url = [NSString stringWithFormat:SYNC_REPORT_EMPLOYEE_URL, enterpriseId, @"1", [latestSyncTime stringValue]];
    
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
        
        [dao batchUpdateReports:records LastSync:lastSync EnterpriseId:enterpriseId];
        
        block(YES);
    }];
}

@end