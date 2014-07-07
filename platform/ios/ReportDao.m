#import "ReportDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"

@implementation ReportDao

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

@end
