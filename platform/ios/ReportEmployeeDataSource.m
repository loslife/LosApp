#import "ReportEmployeeDataSource.h"
#import "EmployeePerformance.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"

@implementation ReportEmployeeDataSource

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(!flag){
        
        self.records = [self.reportDao queryEmployeePerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        block(YES);
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"employee"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *emp = [current objectForKey:@"tb_emp_performance"];
        NSArray *array = [emp objectForKey:[status typeStr]];
        
        [self.reportDao batchInsertEmployeePerformance:array type:[status typeStr]];
        
        [self.records removeAllObjects];
        
        for(NSDictionary *item in array){
            
            NSString *pk = [item objectForKey:@"_id"];
            NSNumber *total = [item objectForKey:@"total"];
            NSString *name = [item objectForKey:@"employee_name"];
            EmployeePerformance *performance = [[EmployeePerformance alloc] initWithPk:pk Total:total Name:name];
            [self.records addObject:performance];
        }
        
        [self.records sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            EmployeePerformance *p1 = (EmployeePerformance*) obj1;
            EmployeePerformance *p2 = (EmployeePerformance*) obj2;
            if([p1.total doubleValue] < [p2.total doubleValue]){
                return NSOrderedDescending;
            }else if([p1.total doubleValue] == [p2.total doubleValue]){
                return NSOrderedSame;
            }else{
                return NSOrderedAscending;
            }
        }];
        
        block(YES);
    }];
}

#pragma mark - employee view datasource

-(BOOL) hasData
{
    return [self.records count] != 0;
}

-(double) totalNumber
{
    double sum = 0;
    for(EmployeePerformance *item in self.records){
        sum += [item.total doubleValue];
    }
    return sum;
}

#pragma mark - bar chart datasource

-(NSUInteger) rowCount
{
    return [self.records count];
}

-(int) maxValue
{
    if([self.records count] == 0){
        return 0;
    }
    
    EmployeePerformance *max = [self.records firstObject];
    return [max.total intValue];
}

-(NSString*) nameAtIndex:(int)index
{
    EmployeePerformance *item = [self.records objectAtIndex:index];
    return item.employeeName;
}

-(double) valueAtIndex:(int)index
{
    EmployeePerformance *item = [self.records objectAtIndex:index];
    return [item.total doubleValue];
}

@end
