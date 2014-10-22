#import "ReportDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "EmployeePerformance.h"
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
    
        [db beginTransaction];
        
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
        
        [db commit];
    }];
}

-(NSMutableArray*) queryBusinessPerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query_day = @"select id, total, service, product, newcard, recharge from biz_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSString *query_month = @"select id, total, service, product, newcard, recharge from biz_performance_month where enterprise_id = :eid and year = :year and month = :month;";
    
    NSString *query_week = @"select id, total, service, product, newcard, recharge from biz_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    __block NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
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
        
        [result addObject:[self assembleRecordFromRS:rs]];
        [result addObject:[self assembleRecordFromRS:rs2]];
        
        [rs close];
        [rs2 close];
    }];
    
    return result;
}

-(NSDictionary*) assembleRecordFromRS:(FMResultSet*)rs
{
    if([rs next]){
        
        NSMutableDictionary *record = [NSMutableDictionary dictionary];
        
        [record setObject:[rs objectForColumnName:@"id"] forKey:@"_id"];
        [record setObject:[rs objectForColumnName:@"total"] forKey:@"total"];
        [record setObject:[rs objectForColumnName:@"service"] forKey:@"service"];
        [record setObject:[rs objectForColumnName:@"product"] forKey:@"product"];
        [record setObject:[rs objectForColumnName:@"newcard"] forKey:@"newcard"];
        [record setObject:[rs objectForColumnName:@"recharge"] forKey:@"recharge"];
        
        return record;
    }
    
    return [NSDictionary dictionary];
}

-(void) insertBusinessPerformance:(NSDictionary*)entity type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"biz_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total, cash, card, bank, service, product, newcard, recharge, create_date, year, month, day) values (:id, :eid, :total, :cash, :card, :bank, :service, :product, :newcard, :recharge, :cdate, :year, :month, :day);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total = :total, cash = :cash, card = :card, bank = :bank, service = :service, product = :product, newcard = :newcard, recharge = :recharge, modify_date = :mdate where year = :year and month = :month and day = :day and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    [dbHelper inDatabase:^(FMDatabase* db){
        
        [db beginTransaction];
        
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
        
        [db commit];
    }];
}

-(int) countBusinessPerformance:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSString *count_day = @"select count(1) as count from biz_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSString *count_month = @"select count(1) as count from biz_performance_month where enterprise_id = :eid and year = :year and month = :month;";
    
    NSString *count_week = @"select count(1) as count from biz_performance_year where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    __block NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    __block int count;
    
    [dbHelper inDatabase:^(FMDatabase* db){
        
        FMResultSet *rs;
        
        if(type == 0){
            
            rs = [db executeQuery:count_day, enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month], [NSNumber numberWithLong:day]];
            
        }else if(type == 1){
            
            rs = [db executeQuery:count_month, enterpriseId, [NSNumber numberWithLong:year], [NSNumber numberWithLong:month]];
            
        }else{
            
            NSDate *sunday = [TimesHelper firstDayOfWeek:date];
            components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sunday];
            NSInteger yearOfSunday = [components year];
            NSInteger monthOfSunday = [components month];
            NSInteger dayOfSunday = [components day];
            
            rs = [db executeQuery:count_week, enterpriseId, [NSNumber numberWithLong:yearOfSunday], [NSNumber numberWithLong:monthOfSunday], [NSNumber numberWithLong:dayOfSunday]];
        }
        
        count = [[rs objectForColumnName:@"count"] intValue];
        
        [rs close];
    }];
    
    return count;
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
    
        [db beginTransaction];
        
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
        
        [db commit];
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
            
            rs = [db executeQuery:@"select walkin, member, day from customer_count_week where enterprise_id = :eid and dateTime = :dateTime order by month, day asc", enterpriseId, [NSNumber numberWithLongLong:sundayNumber]];
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
    
        [db beginTransaction];
        
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
                [db executeUpdate:insert_week, _id, enterpriseId, walkin, member, year, month, day, sundayNumber];
            }
        }
        
        [db commit];
    }];
}

-(NSMutableArray*) queryIncomeByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query_day = @"select * from income_performance_day where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSString *query_month = @"select * from income_performance_month where enterprise_id = :eid and year = :year and month = :month;";
    
    NSString *query_week = @"select * from income_performance_week where enterprise_id = :eid and year = :year and month = :month and day = :day;";
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    __block NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
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
        
        [result addObject:[self assembleIncomeFromRS:rs]];
        [result addObject:[self assembleIncomeFromRS:rs2]];
        
        [rs close];
        [rs2 close];
    }];
    
    return result;
}

-(NSDictionary*) assembleIncomeFromRS:(FMResultSet*)rs
{
    if([rs next]){
        
        NSMutableDictionary *record = [NSMutableDictionary dictionary];
        
        [record setObject:[rs objectForColumnName:@"id"] forKey:@"_id"];
        [record setObject:[rs objectForColumnName:@"rechargecard_bank"] forKey:@"rechargecard_bank"];
        [record setObject:[rs objectForColumnName:@"rechargecard_cash"] forKey:@"rechargecard_cash"];
        [record setObject:[rs objectForColumnName:@"card"] forKey:@"card"];
        [record setObject:[rs objectForColumnName:@"total_paidin_bank"] forKey:@"total_paidin_bank"];
        [record setObject:[rs objectForColumnName:@"total_paidin_cash"] forKey:@"total_paidin_cash"];
        [record setObject:[rs objectForColumnName:@"service_cash"] forKey:@"service_cash"];
        [record setObject:[rs objectForColumnName:@"total_income"] forKey:@"total_income"];
        [record setObject:[rs objectForColumnName:@"newcard_cash"] forKey:@"newcard_cash"];
        [record setObject:[rs objectForColumnName:@"product_cash"] forKey:@"product_cash"];
        [record setObject:[rs objectForColumnName:@"service_bank"] forKey:@"service_bank"];
        [record setObject:[rs objectForColumnName:@"total_prepay"] forKey:@"total_prepay"];
        [record setObject:[rs objectForColumnName:@"total_paidin"] forKey:@"total_paidin"];
        [record setObject:[rs objectForColumnName:@"product_bank"] forKey:@"product_bank"];
        [record setObject:[rs objectForColumnName:@"newcard_bank"] forKey:@"newcard_bank"];
        
        return record;
    }
    
    return [NSDictionary dictionary];
}

-(void) insertIncome:(NSDictionary*)entity type:(NSString*)type
{
    NSString *tableName = [NSString stringWithFormat:@"income_performance_%@", type];
    
    NSString *query = [NSString stringWithFormat:@"select count(1) as count from %@ where year = :year and month = :month and day = :day and enterprise_id = :eid", tableName];
    
    NSString *insert = [NSString stringWithFormat:@"insert into %@ (id, enterprise_id, total_income, total_prepay, total_paidin, total_paidin_bank, total_paidin_cash, service_cash, service_bank, product_cash, product_bank, card, newcard_cash, newcard_bank, rechargecard_cash, rechargecard_bank, year, month, day, create_date) values (:id, :eid, :ti, :tpre, :tpi, :tpib, :tpic, :sc, :sb, :pc, :pb, :card, :nc, :nb, :rc, :rb, :year, :month, :day, :createDate);", tableName];
    
    NSString *update = [NSString stringWithFormat:@"update %@ set total_income = :ti, total_prepay = :tpre, total_paidin = :tpi, total_paidin_bank = :tpib, total_paidin_cash = :tpic, service_cash = :sc, service_bank = :sb, product_cash = :pc, product_bank = :pb, card = :card, newcard_cash = :nc, newcard_bank = :nb, rechargecard_cash = :rc, rechargecard_bank = :rb, modify_date = :mdate where year = :year and month = :month and day = :day and enterprise_id = :eid;", tableName];
    
    NSNumber *now = [NSNumber numberWithLongLong:[TimesHelper now]];
    
    [dbHelper inDatabase:^(FMDatabase* db){
        
        [db beginTransaction];
        
        NSString *_id = [entity objectForKey:@"_id"];
        NSNumber *createDate = [entity objectForKey:@"create_date"];
        NSString *enterpriseId = [entity objectForKey:@"enterprise_id"];
        NSNumber *year = [entity objectForKey:@"year"];
        NSNumber *month = [NSNumber numberWithInt:[[entity objectForKey:@"month"] intValue] + 1];
        NSNumber *day = [entity objectForKey:@"day"];
        NSNumber *rechargeBank = [entity objectForKey:@"rechargecard_bank"];
        NSNumber *rechargeCash = [entity objectForKey:@"rechargecard_cash"];
        NSNumber *card = [entity objectForKey:@"card"];
        NSNumber *paidinBank = [entity objectForKey:@"total_paidin_bank"];
        NSNumber *paidinCash = [entity objectForKey:@"total_paidin_cash"];
        NSNumber *serviceCash = [entity objectForKey:@"service_cash"];
        NSNumber *totalIncome = [entity objectForKey:@"total_income"];
        NSNumber *newCash = [entity objectForKey:@"newcard_cash"];
        NSNumber *productCash = [entity objectForKey:@"product_cash"];
        NSNumber *serviceBank = [entity objectForKey:@"service_bank"];
        NSNumber *totalPrepay = [entity objectForKey:@"total_prepay"];
        NSNumber *totalPaidin = [entity objectForKey:@"total_paidin"];
        NSNumber *productBank = [entity objectForKey:@"product_bank"];
        NSNumber *newBank = [entity objectForKey:@"newcard_bank"];
        
        FMResultSet *rs = [db executeQuery:query, year, month, day, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, _id, enterpriseId, totalIncome, totalPrepay, totalPaidin, paidinBank, paidinCash, serviceCash, serviceBank, productCash, productBank, card, newCash, newBank, rechargeCash, rechargeBank, year, month, day, createDate];
        }else{
            [db executeUpdate:update, totalIncome, totalPrepay, totalPaidin, paidinBank, paidinCash, serviceCash, serviceBank, productCash, productBank, card, newCash, newBank, rechargeCash, rechargeBank, now, year, month, day, enterpriseId];
        }
        [rs close];
        
        [db commit];
    }];
}

@end
