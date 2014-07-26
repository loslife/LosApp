#import "EnterpriseDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "Enterprise.h"
#import "LosDatabaseHelper.h"

@implementation EnterpriseDao

{
    LosDatabaseHelper *dbHelper;
}

-(id) init
{
    self = [super init];
    if(self){
        dbHelper = [LosDatabaseHelper sharedInstance];
    }
    return self;
}

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName account:(NSString*)account
{
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, display, default_shop, create_date, contact_has_sync, enterprise_account) values (:enterpriseId, :name, :contactLatestSync, :display, :default, :createDate, :flag, :account);";
    
    [dbHelper inDatabase:^(FMDatabase *db){
        [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]], @"no", account];
    }];
}

-(int) countEnterprises
{
    __block int count;
    
    [dbHelper inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:@"select count(1) as count from enterprises where display = 'yes';"];
        [rs next];
        count = [[rs objectForColumnName:@"count"] intValue];
        [rs close];
    }];
    
    return count;
}

-(NSArray*) queryAllEnterprises
{
    NSMutableArray *enterprises = [NSMutableArray arrayWithCapacity:1];
    
    [dbHelper inDatabase:^(FMDatabase *db){
        
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
        [rs close];
    }];
    
    return enterprises;
}

-(NSString*) queryEnterpriseNameById:(NSString*)pk
{
    __block NSString *name;
    
    [dbHelper inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:@"select enterprise_name from enterprises where enterprise_id = :eid;", pk];
        [rs next];
        name = [rs objectForColumnName:@"enterprise_name"];
        [rs close];
    }];
    
    return name;
}

-(BOOL) querySyncFlagById:(NSString*)enterpriseId
{
    __block BOOL result;
    
    [dbHelper inDatabase:^(FMDatabase *db){
    
        FMResultSet *rs = [db executeQuery:@"select contact_has_sync from enterprises where enterprise_id = :eid;", enterpriseId];
        [rs next];
        NSString *flag = [rs objectForColumnName:@"contact_has_sync"];
        result = [flag isEqualToString:@"yes"] ? YES : NO;
        [rs close];
    }];
    
    return result;
}

-(NSNumber*) queryLatestSyncTimeById:(NSString*)enterpriseId
{
    __block NSNumber *time;
    
    [dbHelper inDatabase:^(FMDatabase *db){
    
        FMResultSet *rs = [db executeQuery:@"select contact_latest_sync from enterprises where enterprise_id = :eid;", enterpriseId];
        [rs next];
        time = [rs objectForColumnName:@"contact_latest_sync"];
        [rs close];
    }];
    
    return time;
}

-(void) updateSyncFlagById:(NSString*)enterpriseId
{
    [dbHelper inDatabase:^(FMDatabase *db){
        NSString *statement = @"update enterprises set contact_has_sync = 'yes' where enterprise_id = :eid";
        [db executeUpdate:statement, enterpriseId];
    }];
}

-(NSArray*) queryDisplayEnterprises
{
    NSMutableArray *enterprises = [NSMutableArray arrayWithCapacity:1];
    
    [dbHelper inDatabase:^(FMDatabase *db){
    
        FMResultSet *rs = [db executeQuery:@"select enterprise_id, enterprise_name from enterprises where display = 'yes';"];
        while ([rs next]) {
            NSString *pk = [rs objectForColumnName:@"enterprise_id"];
            NSString *name = [rs objectForColumnName:@"enterprise_name"];
            Enterprise *enterprise = [[Enterprise alloc] initWithId:pk Name:name];
            [enterprises addObject:enterprise];
        }
        [rs close];
    }];
    
    return enterprises;
}

-(void) updateDisplayById:(NSString*)enterpriseId value:(NSString*)value
{
    [dbHelper inDatabase:^(FMDatabase *db){
        NSString *statement = @"update enterprises set display = :display where enterprise_id = :eid";
        [db executeUpdate:statement, value, enterpriseId];
    }];
}

-(NSString*) queryAccountById:(NSString*)enterpriseId
{
    __block NSString *account;
    
    [dbHelper inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:@"select enterprise_account from enterprises where enterprise_id = :eid;", enterpriseId];
        [rs next];
        account = [rs objectForColumnName:@"enterprise_account"];
        [rs close];
    }];
    
    return account;
}

@end
