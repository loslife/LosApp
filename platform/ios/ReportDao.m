#import "ReportDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"
#import "BusinessPerformance.h"
#import "ServicePerformance.h"
#import "CustomerCount.h"

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
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, modify_date = :mdate, employee_name = :employeeName where year = :year and month = :month and day = :day and employee_id = :employeeId and enterprise_id = :eid;", tableName];
    
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
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, _id, enterpriseId, total, createDate, employeeId, employeeName, year, month, day];
        }else{
            [db executeUpdate:update, total, now, employeeName, year, month, day, employeeId, enterpriseId];
        }
    }
    
    [db close];
}

-(NSMutableArray*) queryBusinessPerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSString *sql = @"select total, service, product, newcard, recharge from biz_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    components.day--;
    NSDate *yesterday = [calendar dateFromComponents:components];
    NSDateComponents* prevComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:yesterday];
    NSInteger prev_year = [prevComponents year];
    NSInteger prev_month = [prevComponents month];
    NSInteger prev_day = [prevComponents day];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:sql, enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    
    FMResultSet *rs2 = [db executeQuery:sql, enterpriseId, [NSNumber numberWithLong:prev_year], [NSNumber numberWithLong:prev_month], [NSNumber numberWithLong:prev_day]];
    
    NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    
    if([rs next]){
        
        double total = [[rs objectForColumnName:@"total"] doubleValue];
        double service = [[rs objectForColumnName:@"service"] doubleValue];
        double product = [[rs objectForColumnName:@"product"] doubleValue];
        double newcard = [[rs objectForColumnName:@"newcard"] doubleValue];
        double recharge = [[rs objectForColumnName:@"recharge"] doubleValue];
        
        BusinessPerformance *p1 = [[BusinessPerformance alloc] initWithTitle:@"服务业绩" Value:service Ratio:service / total];
        BusinessPerformance *p2 = [[BusinessPerformance alloc] initWithTitle:@"卖品业绩" Value:product Ratio:product / total];
        BusinessPerformance *p3 = [[BusinessPerformance alloc] initWithTitle:@"开卡业绩" Value:newcard Ratio:newcard / total];
        BusinessPerformance *p4 = [[BusinessPerformance alloc] initWithTitle:@"充值业绩" Value:recharge Ratio:recharge / total];
        
        if([rs2 next]){
            
            double service_prev = [[rs2 objectForColumnName:@"service"] doubleValue];
            double product_prev = [[rs2 objectForColumnName:@"product"] doubleValue];
            double newcard_prev = [[rs2 objectForColumnName:@"newcard"] doubleValue];
            double recharge_prev = [[rs2 objectForColumnName:@"recharge"] doubleValue];
            
            [self assembleCompare:p1 currentValue:service prevValue:service_prev];
            [self assembleCompare:p2 currentValue:product prevValue:product_prev];
            [self assembleCompare:p3 currentValue:newcard prevValue:newcard_prev];
            [self assembleCompare:p4 currentValue:recharge prevValue:recharge_prev];
        }
        
        [performances addObject:p1];
        [performances addObject:p2];
        [performances addObject:p3];
        [performances addObject:p4];
    }
    
    [db close];
    
    return performances;
}

-(void) assembleCompare:(BusinessPerformance*)p currentValue:(double)current prevValue:(double)previous
{
    if(current >= previous){
        p.increased = YES;
        p.compareToPrev = current - previous;
        p.compareToPrevRatio = (current - previous) / previous;
    }else{
        p.increased = NO;
        p.compareToPrev = previous - current;
        p.compareToPrevRatio = (previous - current) / previous;
    }
}

-(void) insertBusinessPerformance:(NSDictionary*)entity type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"biz_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, cash, card, bank, service, product, newcard, recharge, create_date, year, month, day) values (:id, :eid, :total, :cash, :card, :bank, :service, :product, :newcard, :recharge, :cdate, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, cash = :cash, card = :card, bank = :bank, service = :service, product = :product, newcard = :newcard, recharge = :recharge, modify_date = :mdate where year = :year and month = :month and day = :day and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSNumber *createDate = [entity objectForKey:@"create_date"];
    NSString *enterpriseId = [entity objectForKey:@"enterprise_id"];
    NSNumber *total = [entity objectForKey:@"total"];
    NSString *_id = [entity objectForKey:@"_id"];
    NSNumber *cash = [entity objectForKey:@"cash"];
    NSNumber *card = [entity objectForKey:@"card"];
    NSNumber *bank = [entity objectForKey:@"bank"];
    NSNumber *service = [entity objectForKey:@"service"];
    NSNumber *product = [entity objectForKey:@"product"];
    NSNumber *newcard = [entity objectForKey:@"newcard"];
    NSNumber *recharge = [entity objectForKey:@"recharge"];
    NSNumber *year = [entity objectForKey:@"year"];
    NSNumber *month = [entity objectForKey:@"month"];
    NSNumber *day = [entity objectForKey:@"day"];
    
    FMResultSet *rs = [db executeQuery:query, year, month, day, enterpriseId];
    [rs next];
    int count = [[rs objectForColumnName:@"count"] intValue];
    if(count == 0){
        [db executeUpdate:insert, _id, enterpriseId, total, cash, card, bank, service, product, newcard, recharge, createDate, year, month, day];
    }else{
        [db executeUpdate:update, total, cash, card, bank, service, product, newcard, recharge, now, year, month, day, enterpriseId];
    }
    
    [db close];
}

-(NSMutableArray*) queryServicePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
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
        rs = [db executeQuery:@"select sum(total) as total_sum, total, project_name from service_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }else if(type == 1){
        rs = [db executeQuery:@"select sum(total) as total_sum, total, project_name from service_performance_month where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }else{
        rs = [db executeQuery:@"select sum(total) as total_sum, total, project_name from service_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
    }
    
    NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    while([rs next]){
        
        double sum = [[rs objectForColumnName:@"total_sum"] doubleValue];
        double total = [[rs objectForColumnName:@"total"] doubleValue];
        NSString *name = [rs objectForColumnName:@"project_name"];
        
        ServicePerformance *performance = [[ServicePerformance alloc] initWithTitle:name Value:total Ratio:total / sum];
        [performances addObject:performance];
    }
    [db close];
    
    return performances;
}

-(void) batchInsertServicePerformance:(NSArray*)array type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"service_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and project_id = :projectId and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, project_id, project_name, project_cateName, project_cateId, create_date, year, month, day) values (:id, :eid, :total, :pid, :pname, :pCateName, :pCateId, :cdate, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, modify_date = :mdate, project_name = :pname where year = :year and month = :month and day = :day and project_id = :pid and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    for(NSDictionary *item in array){
        
        NSNumber *year = [item objectForKey:@"year"];
        NSNumber *month = [item objectForKey:@"month"];
        NSNumber *day = [item objectForKey:@"day"];
        NSString *enterpriseId = [item objectForKey:@"enterprise_id"];
        NSString *_id = [item objectForKey:@"_id"];
        NSNumber *total = [item objectForKey:@"total"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSString *projectName = [item objectForKey:@"project_name"];
        NSString *projectId = [item objectForKey:@"project_id"];
        NSString *projectCateId = [item objectForKey:@"project_cateId"];
        NSString *projectCateName = [item objectForKey:@"project_cateName"];
        
        FMResultSet *rs = [db executeQuery:query, year, month, day, projectId, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, _id, enterpriseId, total, projectId, projectName, projectCateName, projectCateId, createDate, year, month, day];
        }else{
            [db executeUpdate:update, total, now, projectName, year, month, day, projectId, enterpriseId];
        }
    }
    
    [db close];
}

-(NSMutableArray*) queryCustomerCountByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSMutableArray *counts = [NSMutableArray arrayWithCapacity:1];
    
    if(type == 0){
        
        FMResultSet *rs = [db executeQuery:@"select sum(walkin) as total_walkin, sum(member) as total_member, walkin + member as count, hour from customer_count_day where enterprise_id = :eid and year = :year and month = :month and day = :day order by count desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
        
        while([rs next]){
            
            int walkin = [[rs objectForColumnName:@"total_walkin"] intValue];
            int member = [[rs objectForColumnName:@"total_member"] intValue];
            int count = [[rs objectForColumnName:@"count"] intValue];
            int hour = [[rs objectForColumnName:@"hour"] intValue];
            NSString *hour_str = [NSString stringWithFormat:@"%d:00", hour];
            
            CustomerCount *entity = [[CustomerCount alloc] initWithTotalMember:member walkin:walkin count:count title:hour_str];
            [counts addObject:entity];
        }
    }else if(type == 1){
        
        FMResultSet *rs = [db executeQuery:@"select sum(walkin) as total_walkin, sum(member) as total_member, walkin + member as count, day from customer_count_month where enterprise_id = :eid and year = :year and month = :month order by count desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
        
        while([rs next]){
            
            int walkin = [[rs objectForColumnName:@"total_walkin"] intValue];
            int member = [[rs objectForColumnName:@"total_member"] intValue];
            int count = [[rs objectForColumnName:@"count"] intValue];
            int day = [[rs objectForColumnName:@"day"] intValue];
            NSString *day_str = [NSString stringWithFormat:@"%d", day];
            
            CustomerCount *entity = [[CustomerCount alloc] initWithTotalMember:member walkin:walkin count:count title:day_str];
            [counts addObject:entity];
        }
    }else{
        
        FMResultSet *rs = [db executeQuery:@"select sum(walkin) as total_walkin, sum(member) as total_member, walkin + member as count, day from customer_count_week where enterprise_id = :eid and year = :year and month = :month and day = :day order by count desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
        
        while([rs next]){
            
            int walkin = [[rs objectForColumnName:@"total_walkin"] intValue];
            int member = [[rs objectForColumnName:@"total_member"] intValue];
            int count = [[rs objectForColumnName:@"count"] intValue];
            int day = [[rs objectForColumnName:@"day"] intValue];
            NSString *day_str = [NSString stringWithFormat:@"%d", day];
            
            CustomerCount *entity = [[CustomerCount alloc] initWithTotalMember:member walkin:walkin count:count title:day_str];
            [counts addObject:entity];
        }
    }
    
    [db close];
    
    return counts;
}

@end
