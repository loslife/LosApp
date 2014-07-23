#import "ReportServiceDataSource.h"
#import "ServicePerformance.h"
#import "LosAppUrls.h"

@implementation ReportServiceDataSource

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(!flag){
        
        self.records = [self.reportDao queryServicePerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        block(YES);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"service"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *services = [current objectForKey:@"tb_service_performance"];
        NSArray *array = [services objectForKey:[status typeStr]];
        
        [self.reportDao batchInsertServicePerformance:array type:[status typeStr]];
        
        [self.records removeAllObjects];
        
        double sum = 0.0;
        
        for(NSDictionary *item in array){
            
            NSString *title = [item objectForKey:@"project_name"];
            double total = [[item objectForKey:@"total"] doubleValue];
            sum += total;
            ServicePerformance *performance = [[ServicePerformance alloc] initWithTitle:title value:total];
            [self.records addObject:performance];
        }
        
        for(ServicePerformance *item in self.records){
            item.ratio = item.value / sum;
        }
        
        [self.records sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ServicePerformance *s1 = (ServicePerformance*) obj1;
            ServicePerformance *s2 = (ServicePerformance*) obj2;
            if(s1.value < s2.value){
                return NSOrderedDescending;
            }else if(s1.value == s2.value){
                return NSOrderedSame;
            }else{
                return NSOrderedAscending;
            }
        }];
        
        block(YES);
    }];
}

#pragma mark - Service View DataSource

-(BOOL) hasData
{
    return [self.records count] != 0;
}

-(NSString*) total
{
    double sum = 0;
    for(ServicePerformance *item in self.records){
        sum += item.value;
    }
    return [NSString stringWithFormat:@"￥%.1f", sum];
}

-(NSUInteger) itemCount
{
    NSUInteger count = [self.records count];
    if(count > 3){
        return count - 3;
    }
    return 0;
}

-(ServicePerformance*) itemAtIndex:(int)index
{
    return [self.records objectAtIndex:index + 3];
}

#pragma mark - PieChart delegate

-(NSUInteger) pieItemCount
{
    if([self.records count] <= 4){
        return [self.records count];
    }
    return 4;
}

-(LosPieChartItem*) pieItemAtIndex:(int)index
{
    if(index < 3){
        ServicePerformance *performance = [self.records objectAtIndex:index];
        NSString *title = [NSString stringWithFormat:@"%d.%@ %.f%%", index + 1, performance.title, performance.ratio * 100];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:performance.ratio];
    }
    
    double sum = 0.0;
    
    for(int i = 3; i < [self.records count]; i++){
        ServicePerformance *performance = [self.records objectAtIndex:i];
        sum += performance.ratio;
    }
    NSString *title = [NSString stringWithFormat:@"其他 %.f%%", sum * 100];
    return [[LosPieChartItem alloc] initWithTitle:title Ratio:sum];
}

-(UIColor*) colorAtIndex:(int)index
{
    if(index == 0){
        return [UIColor colorWithRed:255/255.0f green:122/255.0f blue:75/255.0f alpha:1.0f];
    }else if(index == 1){
        return [UIColor colorWithRed:252/255.0f green:167/255.0f blue:136/255.0f alpha:1.0f];
    }else if(index == 2){
        return [UIColor colorWithRed:254/255.0f green:207/255.0f blue:190/255.0f alpha:1.0f];
    }else{
        return [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f];
    }
}

@end
