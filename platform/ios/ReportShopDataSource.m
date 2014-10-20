#import "ReportShopDataSource.h"
#import "LosStyles.h"

@implementation ReportShopDataSource

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(!flag){
        
        NSArray *array = [self.reportDao queryBusinessPerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        [self assembleBusinessPerformanceFromRecord1:[array objectAtIndex:0] record2:[array objectAtIndex:1]];
        block(YES);
        
    }else{
        
        NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"business"];
        
        [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
            
            NSDictionary *result = [response objectForKey:@"result"];
            
            NSDictionary *current = [result objectForKey:@"current"];
            NSDictionary *biz = [current objectForKey:@"tb_biz_performance"];
            NSDictionary *record = [biz objectForKey:[status typeStr]];
            
            NSDictionary *prev = [result objectForKey:@"prev"];
            NSDictionary *biz2 = [prev objectForKey:@"tb_biz_performance"];
            NSDictionary *record2 = [biz2 objectForKey:[status typeStr]];
            
            if([record objectForKey:@"_id"]){
                [self.reportDao insertBusinessPerformance:record type:[status typeStr]];
            }
            
            if([record2 objectForKey:@"_id"]){
                [self.reportDao insertBusinessPerformance:record2 type:[status typeStr]];
            }
            
            [self assembleBusinessPerformanceFromRecord1:record record2:record2];
            block(YES);
        }];
    }
}

-(void) assembleBusinessPerformanceFromRecord1:(NSDictionary*)record1 record2:(NSDictionary*)record2
{
    [self.records removeAllObjects];
    
    if(![record1 objectForKey:@"_id"]){
        return;
    }
    
    double total = [[record1 objectForKey:@"total"] doubleValue];
    double service = [[record1 objectForKey:@"service"] doubleValue];
    double product = [[record1 objectForKey:@"product"] doubleValue];
    double newcard = [[record1 objectForKey:@"newcard"] doubleValue];
    double recharge = [[record1 objectForKey:@"recharge"] doubleValue];
    
    BusinessPerformance *p1 = [[BusinessPerformance alloc] initWithTitle:@"服务业绩" Value:service Ratio:service / total];
    BusinessPerformance *p2 = [[BusinessPerformance alloc] initWithTitle:@"卖品业绩" Value:product Ratio:product / total];
    BusinessPerformance *p3 = [[BusinessPerformance alloc] initWithTitle:@"开卡业绩" Value:newcard Ratio:newcard / total];
    BusinessPerformance *p4 = [[BusinessPerformance alloc] initWithTitle:@"充值业绩" Value:recharge Ratio:recharge / total];
    
    double service_prev;
    double product_prev;
    double newcard_prev;
    double recharge_prev;
    
    if([record2 objectForKey:@"_id"]){
        service_prev = [[record2 objectForKey:@"service"] doubleValue];
        product_prev = [[record2 objectForKey:@"product"] doubleValue];
        newcard_prev = [[record2 objectForKey:@"newcard"] doubleValue];
        recharge_prev = [[record2 objectForKey:@"recharge"] doubleValue];
    }else{
        service_prev = 0;
        product_prev = 0;
        newcard_prev = 0;
        recharge_prev = 0;
    }
    
    [self assembleCompare:p1 currentValue:service prevValue:service_prev];
    [self assembleCompare:p2 currentValue:product prevValue:product_prev];
    [self assembleCompare:p3 currentValue:newcard prevValue:newcard_prev];
    [self assembleCompare:p4 currentValue:recharge prevValue:recharge_prev];
    
    [self.records addObject:p1];
    [self.records addObject:p2];
    [self.records addObject:p3];
    [self.records addObject:p4];
}

-(void) assembleCompare:(BusinessPerformance*)p currentValue:(double)current prevValue:(double)previous
{
    if(current >= previous){
        p.increased = YES;
    }else{
        p.increased = NO;
    }
    
    p.compareToPrev = abs(current - previous);
    
    if(previous != 0){
        p.compareToPrevRatio = p.compareToPrev / previous;
    }else if(current == 0){
        p.compareToPrevRatio = 0;
    }else{
        p.compareToPrevRatio = 1;
    }
}

#pragma mark - ReportShopView datasource

-(BOOL) hasData
{
    return [self.records count] != 0;
}

-(NSString*) total
{
    double sum = 0;
    for(BusinessPerformance *item in self.records){
        sum += item.value;
    }
    return [NSString stringWithFormat:@"￥%.1f", sum];
}

-(NSUInteger) itemCount
{
    return [self.records count];
}

-(BusinessPerformance*) itemAtIndex:(int)index
{
    return [self.records objectAtIndex:index];
}

#pragma mark - PieChart delegate

-(NSUInteger) pieItemCount
{
    return [self.records count];
}

-(LosPieChartItem*) pieItemAtIndex:(int)index
{
    BusinessPerformance *performance = [self.records objectAtIndex:index];
    
    NSString *title = [NSString stringWithFormat:@"%@ %.f%%", performance.title, performance.ratio * 100];
    LosPieChartItem *item = [[LosPieChartItem alloc] initWithTitle:title Ratio:performance.ratio];
    return item;
}

-(UIColor*) colorAtIndex:(int)index
{
    if(index == 0){
        return [UIColor colorWithRed:227/255.0f green:110/255.0f blue:66/255.0f alpha:1.0f];
    }else if(index == 1){
        return [UIColor colorWithRed:249/255.0f green:208/255.0f blue:92/255.0f alpha:1.0f];
    }else if(index == 2){
        return BLUE2;
    }else{
        return [UIColor colorWithRed:134/255.0f green:121/255.0f blue:201/255.0f alpha:1.0f];
    }
}

@end
