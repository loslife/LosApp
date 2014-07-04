#import "LosDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"
#import "Enterprise.h"

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
    
    NSArray *days = [records objectForKey:@"day"];
    [self updateDays:days Database:db EnterpriseId:enterpriseId];
    
    NSArray *months = [records objectForKey:@"month"];
    [self updateMonths:months Database:db EnterpriseId:enterpriseId];
    
    NSArray *weeks = [records objectForKey:@"week"];
    [self updateWeeks:weeks Database:db EnterpriseId:enterpriseId];
    
    [db close];
}

-(void) updateDays:(NSArray*)datas Database:(FMDatabase*)db EnterpriseId:(NSString*)enterpriseId
{
    NSString *query = @"select count(1) as count from employee_performance_day where id = :id and enterprise_id = :eid;";
    
    NSString *insert = @"insert into employee_performance_day (id, enterprise_id, total, create_date, modify_date, employee_name, year, month, day, week) values (:id, :eid, :total, :cdate, :mdate, :employeeName, :year, :month, :day, :week);";
    
    NSString *update = @"update employee_performance_day set total = :total, modify_date = :mdate, employee_name = :employeeName where id = :id and enterprise_id = :eid;";
    
    for(NSDictionary *item in datas){
        
        NSString *pk = [item objectForKey:@"id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        NSString *employeeName = [item objectForKey:@"employee_name"];
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSNumber *week = [item objectForKey:@"week"];
        
        FMResultSet *rs = [db executeQuery:query, pk, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, pk, enterpriseId, total, createDate, modifyDate, employeeName, year, month, day, week];
        }else{
            [db executeUpdate:update, total, modifyDate, employeeName, pk, enterpriseId];
        }
    }
}

-(void) updateMonths:(NSArray*)datas Database:(FMDatabase*)db EnterpriseId:(NSString*)enterpriseId
{
    NSString *query = @"select count(1) as count from employee_performance_month where id = :id and enterprise_id = :eid;";
    
    NSString *insert = @"insert into employee_performance_month (id, enterprise_id, total, create_date, modify_date, employee_name, year, month, day, week) values (:id, :eid, :total, :cdate, :mdate, :employeeName, :year, :month, :day, :week);";
    
    NSString *update = @"update employee_performance_month set total = :total, modify_date = :mdate, employee_name = :employeeName where id = :id and enterprise_id = :eid;";
    
    for(NSDictionary *item in datas){
        
        NSString *pk = [item objectForKey:@"id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        NSString *employeeName = [item objectForKey:@"employee_name"];
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSNumber *week = [item objectForKey:@"week"];
        
        FMResultSet *rs = [db executeQuery:query, pk, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, pk, enterpriseId, total, createDate, modifyDate, employeeName, year, month, day, week];
        }else{
            [db executeUpdate:update, total, modifyDate, employeeName, pk, enterpriseId];
        }
    }
}

-(void) updateWeeks:(NSArray*)datas Database:(FMDatabase*)db EnterpriseId:(NSString*)enterpriseId
{
    NSString *query = @"select count(1) as count from employee_performance_week where id = :id and enterprise_id = :eid;";
    
    NSString *insert = @"insert into employee_performance_week (id, enterprise_id, total, create_date, modify_date, employee_name, year, month, day, week) values (:id, :eid, :total, :cdate, :mdate, :employeeName, :year, :month, :day, :week);";
    
    NSString *update = @"update employee_performance_week set total = :total, modify_date = :mdate, employee_name = :employeeName where id = :id and enterprise_id = :eid;";
    
    for(NSDictionary *item in datas){
        
        NSString *pk = [item objectForKey:@"id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        NSString *employeeName = [item objectForKey:@"employee_name"];
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSNumber *week = [item objectForKey:@"week"];
        
        FMResultSet *rs = [db executeQuery:query, pk, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, pk, enterpriseId, total, createDate, modifyDate, employeeName, year, month, day, week];
        }else{
            [db executeUpdate:update, total, modifyDate, employeeName, pk, enterpriseId];
        }
    }
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
    
    FMResultSet *rs;
    
    if(type == 0){
        rs = [db executeQuery:@"select id, total, employee_name from employee_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }else if(type == 1){
        rs = [db executeQuery:@"select id, total, employee_name from employee_performance_month where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }else{
        rs = [db executeQuery:@"select id, total, employee_name from employee_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }
    
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
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_id, enterprise_name from enterprises;"];
    while ([rs next]) {
        NSString *pk = [rs objectForColumnName:@"enterprise_id"];
        NSString *name = [rs objectForColumnName:@"enterprise_name"];
        Enterprise *enterprise = [[Enterprise alloc] initWithId:pk Name:name];
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

@end
