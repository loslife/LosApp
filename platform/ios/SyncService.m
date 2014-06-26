#import "SyncService.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"

@implementation SyncService

{
    LosHttpHelper *httpHelper;
}

-(id) init
{
    self = [super init];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
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
        
        [self handleDatabase:enterpriseId Name:enterpriseName];
        
        [self refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:[NSNumber numberWithInt:0] Block:^(BOOL flag){
            block(0);
        }];
    }];
}

-(void) handleDatabase:(NSString*)enterpriseId Name:(NSString*)enterpriseName
{
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, report_latest_sync, display, create_date) values (:enterpriseId, :name, :contactLatestSync, :reportLatestSync, :display, :createDate);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithLongLong:[TimesHelper now]]];
    
    [db close];
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
        [self handleEnterprises:enterprises];
        
        block(YES);
    }];
}

-(void) handleEnterprises:(NSArray*)enterprises
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, report_latest_sync, display, create_date) values (:enterpriseId, :name, :contactLatestSync, :reportLatestSync, :display, :createDate);";
    NSString *update = @"update enterprises set enterprise_name = :name where enterprise_id = :id";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    for(NSDictionary *item in enterprises){
        
        NSString *enterpriseId = [item objectForKey:@"enterprise_id"];
        NSString *enterpriseName = [item objectForKey:@"enterprise_name"];
        FMResultSet *rs = [db executeQuery:query, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithLongLong:[TimesHelper now]]];
        }else{
            [db executeUpdate:update, enterpriseName, enterpriseId];
        }
    }
    
    [db close];
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
        
        [self handleDatabase:records LastSync:lastSync EnterpriseId:enterpriseId];
        
        block(YES);
    }];
}

-(void) handleDatabase:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    // 刷新最后同步时间
    NSString *refreshLatestSyncTime = @"update enterprises set contact_latest_sync = :sync where enterprise_id = :enterpriseId;";
    [db executeUpdate:refreshLatestSyncTime, lastSync, enterpriseId];
    
    // 处理新增记录
    NSArray *add = [records objectForKey:@"add"];
    NSString *insert = @"insert into members (id, enterprise_id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume, create_date, modify_date) values (:id, :eid, :name, :birthday, :phoneMobile, :joinDate, :memberNo, :latest, :total, :average, :cdate, :mdate);";
    
    for(NSDictionary *item in add){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *birthday = [item objectForKey:@"birthday"];
        NSString *phone = [item objectForKey:@"phoneMobile"];
        NSNumber *joinDate = [item objectForKey:@"joinDate"];
        NSString *memberNo = [item objectForKey:@"memberNo"];
        NSNumber *latest = [item objectForKey:@"latestConsumeTime"];
        NSNumber *total = [item objectForKey:@"totalConsume"];
        NSNumber *average = [item objectForKey:@"averageConsume"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:insert, pk, enterpriseId, name, birthday, phone, joinDate, memberNo, latest, total, average, createDate, modifyDate];
    }
    
    // 处理更新记录
    NSArray *update = [records objectForKey:@"update"];
    NSString *statement = @"update members set name = :name, birthday = :birthday, phoneMobile = :phone, joinDate = :joinDate, memberNo = :memberNo, latestConsumeTime = :latest, totalConsume = :total, averageConsume = :average, modify_date = :mdate where id = :id";
    
    for(NSDictionary *item in update){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *birthday = [item objectForKey:@"birthday"];
        NSString *phone = [item objectForKey:@"phoneMobile"];
        NSNumber *joinDate = [item objectForKey:@"joinDate"];
        NSString *memberNo = [item objectForKey:@"memberNo"];
        NSNumber *latest = [item objectForKey:@"latestConsumeTime"];
        NSNumber *total = [item objectForKey:@"totalConsume"];
        NSNumber *average = [item objectForKey:@"averageConsume"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:statement, name, birthday, phone, joinDate, memberNo, latest, total, average, modifyDate, pk];
    }
    
    // 处理remove
    NSArray *remove = [records objectForKey:@"remove"];
    NSString *deleteStatement = @"delete from members where id = :id";
    
    for(NSDictionary *item in remove){
        NSString *pk = [item objectForKey:@"id"];
        [db executeUpdate:deleteStatement, pk];
    }
    
    [db close];
}

@end
