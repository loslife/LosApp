#import "ReportCustomDataSource.h"
#import "CustomerCount.h"
#import "TimesHelper.h"

@implementation ReportCustomDataSource

{
    NSMutableArray *top3;
}

-(id) init
{
    self = [super init];
    if(self){
        top3 = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(!flag){
        
        self.records = [self.reportDao queryCustomerCountByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        [self resolveTop3];
        block(YES);
        return;
    }
    
    NSString *type = [status typeStr];
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], type, @"customer"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *b_customer = [current objectForKey:@"b_customer_count"];
        
        NSDictionary *summary = [b_customer objectForKey:type];
        NSNumber *member_total = [summary objectForKey:@"member"];
        NSNumber *walkin_total = [summary objectForKey:@"temp"];
        
        if(!member_total){
            member_total = [NSNumber numberWithInt:0];
        }
        
        if(!walkin_total){
            walkin_total = [NSNumber numberWithInt:0];
        }
        
        NSArray *details;
        if([type isEqualToString:@"day"]){
            details = [b_customer objectForKey:@"hours"];
        }else{
            details = [b_customer objectForKey:@"days"];
        }
        
        NSArray *filled = [self filledArray:details forType:type];// 填充数组缺失数据
        
        [self.reportDao batchInsertCustomerCount:filled type:type];
        
        [self.records removeAllObjects];
        
        for(NSDictionary *item in filled){
            
            NSNumber *member_count = [item objectForKey:@"member"];
            NSNumber *walkin_count = [item objectForKey:@"temp"];
            NSNumber *day = [item objectForKey:@"day"];
            NSNumber *hour = [item objectForKey:@"hour"];
            
            NSString *title;
            if([type isEqualToString:@"day"]){
                title = [NSString stringWithFormat:@"%d:00", [hour intValue]];
            }else{
                title = [NSString stringWithFormat:@"%d", [day intValue]];
            }
            
            CustomerCount *entity = [[CustomerCount alloc] initWithTotalMember:[member_total intValue] walkin:[walkin_total intValue] count:[member_count intValue] + [walkin_count intValue] title:title];
            
            [self.records addObject:entity];
        }
        
        [self resolveTop3];
        block(YES);
    }];
}

-(NSArray*) filledArray:(NSArray*)origin forType:(NSString*)type
{
    NSMutableArray *filled = [NSMutableArray arrayWithCapacity:1];
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    int year = [status year];
    int month = [status month];
    int day = [status day];
    
    NSDate *sunday = [TimesHelper firstDayOfWeek:status.date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:sunday];
    
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    for(int i = 0; i < [origin count]; i++){
        
        NSDate *date = [calendar dateFromComponents:components];
        components = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        components.day ++;
        
        NSDictionary *item = [origin objectAtIndex:i];
        
        NSString *_id = [item objectForKey:@"_id"];
        
        if(![StringUtils isEmpty:_id]){
            [filled addObject:item];
            continue;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
        
        [dict setObject:[[NSUUID UUID] UUIDString] forKey:@"_id"];
        [dict setObject:currentEnterpriseId forKey:@"enterprise_id"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"member"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"temp"];
        [dict setObject:[NSNumber numberWithInt:year] forKey:@"year"];
        [dict setObject:[NSNumber numberWithInt:(month - 1)] forKey:@"month"];
        
        if([type isEqualToString:@"day"]){
            [dict setObject:[NSNumber numberWithInt:day] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:i] forKey:@"hour"];
        }else if([type isEqualToString:@"month"]){
            [dict setObject:[NSNumber numberWithInt:i + 1] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"hour"];
        }else{
            [dict setObject:[NSNumber numberWithLong:components.day - 1] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"hour"];
        }
        
        [filled addObject:dict];
    }
    
    return filled;
}

-(void) resolveTop3
{
    [top3 removeAllObjects];
    
    NSArray *sorted = [self.records sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomerCount *entity1 = (CustomerCount*)obj1;
        CustomerCount *entity2 = (CustomerCount*)obj2;
        if(entity1.count < entity2.count){
            return NSOrderedDescending;
        }else if(entity1.count == entity2.count){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    int itemInTop3 = 0;
    
    for(int i = 0; i < [sorted count]; i++){
        
        if(itemInTop3 == 3){
            break;
        }
        
        CustomerCount *entity = [sorted objectAtIndex:i];
        
        if(i == 0){
            [top3 addObject:[NSNumber numberWithInt:entity.count]];
            itemInTop3 ++;
            continue;
        }
        
        CustomerCount *prev = [sorted objectAtIndex:i-1];
        if(entity.count != prev.count){
            [top3 addObject:[NSNumber numberWithInt:entity.count]];
            itemInTop3 ++;
        }
    }
}

#pragma mark - customer view datasource

-(BOOL) hasData
{
    return [self.records count] != 0;
}

-(NSUInteger) memberCount
{
    CustomerCount *entity = [self.records firstObject];
    return entity.totalMember;
}

-(NSUInteger) walkinCount
{
    CustomerCount *entity = [self.records firstObject];
    return entity.totalWalkin;
}

#pragma mark - line chart datasource

-(NSUInteger) valuePerSection
{
    double max = 0.0;
    
    for(CustomerCount *entity in self.records){
        if(entity.count > max){
            max = entity.count;
        }
    }
    
    if(max < 5){
        return 1;
    }
    
    return ceil(max / 5);
}

-(NSUInteger) itemCount
{
    return [self.records count];
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    CustomerCount *entity = [self.records objectAtIndex:index];
    
    int order = 4;
    
    if(entity.count == [[top3 firstObject] intValue]){
        order = 1;
    }else if(entity.count == [[top3 objectAtIndex:1] intValue]){
        order = 2;
    }else if(entity.count == [[top3 objectAtIndex:2] intValue]){
        order = 3;
    }
    
    LosLineChartItem *item = [[LosLineChartItem alloc] initWithTitle:entity.title value:entity.count order:order];
    return item;
}

@end
