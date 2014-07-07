#import "ReportDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"

@implementation ReportDao

-(NSMutableArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
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

-(void) batchInsertEmployeePerformance:(NSArray*)array type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"employee_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and employee_id = :employeeId and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, create_date, employee_id, employee_name, year, month, day) values (:id, :eid, :total, :cdate, :employeeId, :employeeName, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, modify_date = :mdate, employee_name = :employeeName where year = :year, month = :month, day = :day, employee_id = :employeeId, enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    for(NSDictionary *item in array){
        
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSString *employeeId = [item objectForKey:@"employee_id"];
        NSString *employeeName = [item objectForKey:@"employee_name"];
        NSString *enterpriseId = [item objectForKey:@"enterprise_id"];
        NSString *_id = [item objectForKey:@"_id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        
        FMResultSet *rs = [db executeQuery:query, year, month, day, employeeId, enterpriseId];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, _id, enterpriseId, total, createDate, employeeId, employeeName, year, month, day];
        }else{
            [db executeUpdate:update, total, now, employeeName, year, month, day, employeeId, enterpriseId];
        }
    }
    
    [db close];
}

@end
