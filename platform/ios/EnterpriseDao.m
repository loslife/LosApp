#import "EnterpriseDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "Enterprise.h"

@implementation EnterpriseDao

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName
{
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, display, default_shop, create_date, contact_has_sync) values (:enterpriseId, :name, :contactLatestSync, :display, :default, :createDate, :flag);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]], @"no"];
    
    [db close];
}

-(void) batchInsertEnterprises:(NSArray*)enterprises
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, display, default_shop, create_date, contact_has_sync) values (:enterpriseId, :name, :contactLatestSync, :display, :default, :createDate, :flag);";
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
            [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]], @"no"];
        }else{
            [db executeUpdate:update, enterpriseName, enterpriseId];
        }
    }
    
    [db close];
}

-(int) countEnterprises
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select count(1) as count from enterprises;"];
    [rs next];
    int count = [[rs objectForColumnName:@"count"] intValue];
    
    [db close];
    
    return count;
}

-(NSArray*) queryAllEnterprises
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSMutableArray *enterprises = [NSMutableArray arrayWithCapacity:1];
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_id, enterprise_name, display from enterprises order by display desc;"];
    while ([rs next]) {
        NSString *pk = [rs objectForColumnName:@"enterprise_id"];
        NSString *name = [rs objectForColumnName:@"enterprise_name"];
        NSString *display = [rs objectForColumnName:@"display"];
        int state;
        if([display isEqualToString:@"yes"]){
            state = 1;
        }else{
            state = 0;
        }
        Enterprise *enterprise = [[Enterprise alloc] initWithId:pk Name:name state:state];
        [enterprises addObject:enterprise];
    }
    
    [db close];
    
    return enterprises;
}

-(NSString*) queryEnterpriseNameById:(NSString*)pk
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_name from enterprises where enterprise_id = :eid;", pk];
    [rs next];
    NSString *name = [rs objectForColumnName:@"enterprise_name"];
    
    [db close];
    
    return name;
}

-(BOOL) querySyncFlagById:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select contact_has_sync from enterprises where enterprise_id = :eid;", enterpriseId];
    [rs next];
    NSString *flag = [rs objectForColumnName:@"contact_has_sync"];
    BOOL result = [flag isEqualToString:@"yes"] ? YES : NO;
    
    [db close];
    
    return result;
}

-(NSNumber*) queryLatestSyncTimeById:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select contact_latest_sync from enterprises where enterprise_id = :eid;", enterpriseId];
    [rs next];
    NSNumber *time = [rs objectForColumnName:@"contact_latest_sync"];
    
    [db close];
    
    return time;
}

-(void) updateSyncFlagById:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSString *statement = @"update enterprises set contact_has_sync = 'yes' where enterprise_id = :eid";
    [db executeUpdate:statement, enterpriseId];
    
    [db close];
}

@end
