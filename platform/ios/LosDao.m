#import "LosDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"

@implementation LosDao

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName
{
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, report_latest_sync, display, default_shop, create_date) values (:enterpriseId, :name, :contactLatestSync, :reportLatestSync, :display, :default, :createDate);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]]];
    
    [db close];
}

-(void) batchInsertEnterprises:(NSArray*)enterprises
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, report_latest_sync, display, default_shop, create_date) values (:enterpriseId, :name, :contactLatestSync, :reportLatestSync, :display, :default, :createDate);";
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
            [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]]];
        }else{
            [db executeUpdate:update, enterpriseName, enterpriseId];
        }
    }
    
    [db close];
}

-(void) batchUpdateMembers:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId
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

-(void) batchUpdateReports:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    // 刷新最后同步时间
    NSString *refreshLatestSyncTime = @"update enterprises set report_latest_sync = :sync where enterprise_id = :enterpriseId;";
    [db executeUpdate:refreshLatestSyncTime, lastSync, enterpriseId];
    
    NSString *query = @"select count(1) as count from employee_performance where id = :id and enterprise_id = :eid;";
    
    NSString *insert = @"insert into employee_performance (id, enterprise_id, total, create_date, modify_date, type, employee_name, year, month, day, week) values (:id, :eid, :total, :cdate, :mdate, :type, :employeeName, :year, :month, :day, :week);";
    
    NSString *update = @"update employee_performance set total = :total, modify_date = :mdate, employee_name = :employeeName where id = :id and enterprise_id = :eid;";
    
    for(NSDictionary *item in records){
        
        NSString *pk = [item objectForKey:@"id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        NSNumber *type = [item objectForKey:@"type"];
        NSString *employeeName = [item objectForKey:@"employee_name"];
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSNumber *week = [item objectForKey:@"week"];
        
        FMResultSet *rs = [db executeQuery:query, pk, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, pk, enterpriseId, total, createDate, modifyDate, type, employeeName, year, month, day, week];
        }else{
            [db executeUpdate:update, total, modifyDate, employeeName, pk, enterpriseId];
        }
    }
    
    [db close];
}

-(NSArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select id, total, employee_name from employee_performance where enterprise_id = :eid and type = :type and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithInt:type], [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    
    NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    while([rs next]){
        NSString *pk = [rs objectForColumnName:@"id"];
        NSNumber *total = [rs objectForColumnName:@"total"];
        NSString *name = [rs objectForColumnName:@"employee_name"];
        EmployeePerformance *performance = [[EmployeePerformance alloc] initWithPk:pk Total:total Name:name];
        [performances addObject:performance];
    }
    [db close];
    
    return performances;
}

@end
