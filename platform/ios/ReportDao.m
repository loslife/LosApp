#import "ReportDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"
#import "BusinessPerformance.h"
#import "ServicePerformance.h"
#import "CustomerCount.h"
#import "LosDatabaseHelper.h"

@implementation ReportDao

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

-(NSMutableArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSDate *sunday = [TimesHelper firstDayOfWeek:date];
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sunday];
    NSInteger yearOfSunday = [components year];
    NSInteger monthOfSunday = [components month];
    NSInteger dayOfSunday = [components day];
    
    NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        FMResultSet *rs;
        
        if(type == 0){
            rs = [db executeQuery:@"select id, total, employee_name from employee_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
        }else if(type == 1){
            rs = [db executeQuery:@"select id, total, employee_name from employee_performance_month where enterprise_id = :eid and year = :year and month = :month order by total desc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
        }else{
            rs = [db executeQuery:@"select id, total, employee_name from employee_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day order by total desc", enterpriseId, [NSNumber numberWithLong:yearOfSunday], [NSNumber numberWithLong:monthOfSunday], [NSNumber numberWithLong:dayOfSunday]];
        }
        
        while([rs next]){
            NSString *pk = [rs objectForColumnName:@"id"];
            NSNumber *total = [rs objectForColumnName:@"total"];
            NSString *name = [rs objectForColumnName:@"employee_name"];
            EmployeePerformance *performance = [[EmployeePerformance alloc] initWithPk:pk Total:total Name:name];
            [performances addObject:performance];
        }
        
        [rs close];
    }];
    
    return performances;
}

-(void) batchInsertEmployeePerformance:(NSArray*)array type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"employee_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and employee_id = :employeeId and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, create_date, employee_id, employee_name, year, month, day) values (:id, :eid, :total, :cdate, :employeeId, :employeeName, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, modify_date = :mdate, employee_name = :employeeName where year = :year and month = :month and day = :day and employee_id = :employeeId and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        for(NSDictionary *item in array){
            
            NSNumber *year = [item objectForKey:@"year"];
            NSNumber *month = [NSNumber numberWithInt:[[item objectForKey:@"month"] intValue] + 1];// server返回的month是月份-1
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
            [rs close];
        }
    }];
}

-(NSMutableArray*) queryBusinessPerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSString *query_day = @"select total, service, product, newcard, recharge from biz_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSString *query_month = @"select total, service, product, newcard, recharge from biz_performance_month where enterprise_id = :eid and year = :year and month = :month;";
    
    NSString *query_week = @"select total, service, product, newcard, recharge from biz_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    __block NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    __block NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        FMResultSet *rs;
        FMResultSet *rs2;
        
        if(type == 0){
            
            NSDate *yesterday = [TimesHelper yesterdayOfDay:date];
            components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:yesterday];
            NSInteger yearOfYesterday = [components year];
            NSInteger monthOfYesterday = [components month];
            NSInteger dayOfYesterday = [components day];
            
            rs = [db executeQuery:query_day, enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
            rs2 = [db executeQuery:query_day, enterpriseId, [NSNumber numberWithLong:yearOfYesterday], [NSNumber numberWithLong:monthOfYesterday], [NSNumber numberWithLong:dayOfYesterday]];
            
        }else if(type == 1){
            
            NSDate *previousMonth = [TimesHelper previousMonthOfDate:date];
            components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:previousMonth];
            NSInteger yearOfPreviousMonth = [components year];
            NSInteger monthOfPreviousMonth = [components month];
            
            rs = [db executeQuery:query_month, enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
            rs2 = [db executeQuery:query_month, enterpriseId, [NSNumber numberWithLong:yearOfPreviousMonth], [NSNumber numberWithLong:monthOfPreviousMonth]];
            
        }else{
            
            NSDate *sunday = [TimesHelper firstDayOfWeek:date];
            components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sunday];
            NSInteger yearOfSunday = [components year];
            NSInteger monthOfSunday = [components month];
            NSInteger dayOfSunday = [components day];
            
            NSDate *previousSunday = [TimesHelper previousSundayOfDate:date];
            components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:previousSunday];
            NSInteger yearOfPreviousSunday = [components year];
            NSInteger monthOfPreviousSunday = [components month];
            NSInteger dayOfPreviousSunday = [components day];
            
            rs = [db executeQuery:query_week, enterpriseId, [NSNumber numberWithLong:yearOfSunday], [NSNumber numberWithLong:monthOfSunday], [NSNumber numberWithLong:dayOfSunday]];
            rs2 = [db executeQuery:query_week, enterpriseId, [NSNumber numberWithLong:yearOfPreviousSunday], [NSNumber numberWithLong:monthOfPreviousSunday], [NSNumber numberWithLong:dayOfPreviousSunday]];
        }
        
        performances = [self assembleResult:rs rs2:rs2];
        
        [rs close];
        [rs2 close];
    }];
    
    return performances;
}

-(NSMutableArray*) assembleResult:(FMResultSet*)rs1 rs2:(FMResultSet*)rs2
{
    NSMutableArray *performances = [NSMutableArray arrayWithCapacity:1];
    
    if([rs1 next]){
        
        double total = [[rs1 objectForColumnName:@"total"] doubleValue];
        double service = [[rs1 objectForColumnName:@"service"] doubleValue];
        double product = [[rs1 objectForColumnName:@"product"] doubleValue];
        double newcard = [[rs1 objectForColumnName:@"newcard"] doubleValue];
        double recharge = [[rs1 objectForColumnName:@"recharge"] doubleValue];
        
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
    
    [dbHelper inDatabase:^(FMDatabase* db){
        
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
        NSNumber *month = [NSNumber numberWithInt:[[entity objectForKey:@"month"] intValue] + 1];
        NSNumber *day = [entity objectForKey:@"day"];
        
        FMResultSet *rs = [db executeQuery:query, year, month, day, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, _id, enterpriseId, total, cash, card, bank, service, product, newcard, recharge, createDate, year, month, day];
        }else{
            [db executeUpdate:update, total, cash, card, bank, service, product, newcard, recharge, now, year, month, day, enterpriseId];
        }
        [rs close];
    }];
}

-(NSArray*) queryServicePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSDate *sunday = [TimesHelper firstDayOfWeek:date];
    components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sunday];
    NSInteger yearOfSunday = [components year];
    NSInteger monthOfSunday = [components month];
    NSInteger dayOfSunday = [components day];
    
    NSMutableArray *records = [NSMutableArray arrayWithCapacity:1];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        FMResultSet *rs;
        
        if(type == 0){
            rs = [db executeQuery:@"select total, project_cateId, project_cateName from service_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
        }else if(type == 1){
            rs = [db executeQuery:@"select total, project_cateId, project_cateName from service_performance_month where enterprise_id = :eid and year = :year and month = :month", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
        }else{
            rs = [db executeQuery:@"select total, project_cateId, project_cateName from service_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day", enterpriseId, [NSNumber numberWithLong:yearOfSunday], [NSNumber numberWithLong:monthOfSunday], [NSNumber numberWithLong:dayOfSunday]];
        }

        while([rs next]){
            
            NSNumber *total = [rs objectForColumnName:@"total"];
            NSString *cateId = [rs objectForColumnName:@"project_cateId"];
            NSString *cateName = [rs objectForColumnName:@"project_cateName"];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:total, @"total", cateId, @"project_cateId", cateName, @"project_cateName", nil];
            
            [records addObject:dictionary];
        }
        
        [rs close];
    }];
    
    return records;
}

-(void) batchInsertServicePerformance:(NSArray*)array type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"service_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and project_id = :projectId and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, project_id, project_name, project_cateName, project_cateId, create_date, year, month, day) values (:id, :eid, :total, :pid, :pname, :pCateName, :pCateId, :cdate, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, modify_date = :mdate, project_name = :pname where year = :year and month = :month and day = :day and project_id = :pid and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        for(NSDictionary *item in array){
            
            NSNumber *year = [item objectForKey:@"year"];
            NSNumber *month = [NSNumber numberWithInt:[[item objectForKey:@"month"] intValue] + 1];
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
            [rs close];
        }
    }];
}

-(NSMutableArray*) queryCustomerCountByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSMutableArray *result = [NSMutableArray array];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        FMResultSet *rs;
        
        if(type == 0){
            
            rs = [db executeQuery:@"select walkin, member, hour from customer_count_day where enterprise_id = :eid and year = :year and month = :month and day = :day order by hour asc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
        }else if(type == 1){
            
            rs = [db executeQuery:@"select walkin, member, day from customer_count_month where enterprise_id = :eid and year = :year and month = :month order by day asc", enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
        }else{
            
            NSDate *sunday = [TimesHelper firstDayOfWeek:date];
            NSTimeInterval sundayNumber = [sunday timeIntervalSince1970];
            
            rs = [db executeQuery:@"select walkin, member, day from customer_count_week where enterprise_id = :eid and dateTime = :dateTime order by day asc", enterpriseId, [NSNumber numberWithLongLong:sundayNumber]];
        }
        
        int walkin_total = 0;
        int member_total = 0;
        
        while([rs next]){
            
            int walkin = [[rs objectForColumnName:@"walkin"] intValue];
            int member = [[rs objectForColumnName:@"member"] intValue];
            NSString *title;
            
            if(type == 0){
                int hour = [[rs objectForColumnName:@"hour"] intValue];
                title = [NSString stringWithFormat:@"%d:00", hour];
            }else{
                int day = [[rs objectForColumnName:@"day"] intValue];
                title = [NSString stringWithFormat:@"%d", day];
            }

            CustomerCount *entity = [[CustomerCount alloc] initWithCount:walkin + member title:title];
            [result addObject:entity];
            
            walkin_total += walkin;
            member_total += member;
        }
        
        for(CustomerCount *item in result){
            item.totalMember = member_total;
            item.totalWalkin = walkin_total;
        }
        
        [rs close];
    }];
    
    return result;
}

-(void) batchInsertCustomerCount:(NSArray*)array type:(NSString*)type
{
    NSString *delete_day = @"delete from customer_count_day where year = :year and month = :month and day = :day and enterprise_id = :eid";
    
    NSString *insert_day = @"insert into customer_count_day (id, enterprise_id, walkin, member, year, month, day, hour) values (:id, :eid, :walkin, :member, :year, :month, :day, :hour);";
    
    NSString *delete_month = @"delete from customer_count_month where year = :year and month = :month and enterprise_id = :eid";
    
    NSString *insert_month = @"insert into customer_count_month (id, enterprise_id, walkin, member, year, month, day) values (:id, :eid, :walkin, :member, :year, :month, :day)";
    
    NSString *delete_week = @"delete from customer_count_week where dateTime = :dateTime and enterprise_id = :eid";
    
    NSString *insert_week = @"insert into customer_count_week (id, enterprise_id, walkin, member, year, month, day, dateTime) values (:id, :eid, :walkin, :member, :year, :month, :day, :dateTime);";
    
    NSDictionary *firstObject = [array firstObject];
    
    NSNumber *year = [firstObject objectForKey:@"year"];
    NSNumber *month = [NSNumber numberWithInt:[[firstObject objectForKey:@"month"] intValue] + 1];
    NSNumber *day = [firstObject objectForKey:@"day"];
    NSString *enterpriseId = [firstObject objectForKey:@"enterprise_id"];
    
    NSDate *date = [TimesHelper dateWithYear:[year intValue] month:[month intValue] day:[day intValue]];
    NSTimeInterval sunday = [[TimesHelper firstDayOfWeek:date] timeIntervalSince1970];
    NSNumber *sundayNumber = [NSNumber numberWithDouble:sunday];
    
    [dbHelper inDatabase:^(FMDatabase* db){
    
        if([type isEqualToString:@"day"]){
            [db executeUpdate:delete_day, year, month, day, enterpriseId];
        }else if([type isEqualToString:@"month"]){
            [db executeUpdate:delete_month, year, month, enterpriseId];
        }else{
            [db executeUpdate:delete_week, sundayNumber, enterpriseId];
        }
        
        for(NSDictionary *item in array){
            
            NSNumber *year = [item objectForKey:@"year"];
            NSNumber *month = [NSNumber numberWithInt:[[item objectForKey:@"month"] intValue] + 1];
            NSNumber *day = [item objectForKey:@"day"];
            NSNumber *hour = [item objectForKey:@"hour"];
            NSString *_id = [item objectForKey:@"_id"];
            NSNumber *member = [item objectForKey:@"member"];
            NSNumber *walkin = [item objectForKey:@"temp"];
            
            if([type isEqualToString:@"day"]){
                [db executeUpdate:insert_day, _id, enterpriseId, walkin, member, year, month, day, hour];
            }else if([type isEqualToString:@"month"]){
                [db executeUpdate:insert_month, _id, enterpriseId, walkin, member, year, month, day];
            }else{
                NSDate *date = [TimesHelper dateWithYear:[year intValue] month:[month intValue] day:[day intValue]];
                NSTimeInterval sunday = [[TimesHelper firstDayOfWeek:date] timeIntervalSince1970];
                NSNumber *sundayNumber = [NSNumber numberWithDouble:sunday];
                [db executeUpdate:insert_week, _id, enterpriseId, walkin, member, year, month, day, sundayNumber];
            }
        }
    }];
}

@end
