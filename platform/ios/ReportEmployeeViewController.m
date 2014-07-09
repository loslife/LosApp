#import "ReportEmployeeViewController.h"
#import "ReportEmployeeView.h"
#import "ReportDao.h"
#import "UserData.h"
#import "ReportShopViewController.h"
#import "ReportDateStatus.h"
#import "StringUtils.h"
#import "EmployeePerformance.h"

@implementation ReportEmployeeViewController

{
    NSMutableArray *records;
}

-(id) init
{
    self = [super init];
    if(self){
        
        records = [NSMutableArray array];
        
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        
        self.tabBarItem.title = @"经营";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_report"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    ReportEmployeeView *view = [[ReportEmployeeView alloc] initWithController:self];
    self.view = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [super initEnterprises];
        [self loadReport];
    });
}

-(void) loadReport
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([StringUtils isEmpty:currentEnterpriseId]){
        return;
    }
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(![LosHttpHelper isNetworkAvailable]){
        
        records = [self.reportDao queryEmployeePerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportEmployeeView *myView = (ReportEmployeeView*)self.view;
            [myView.barView reload];
        });
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"employee"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *emp = [current objectForKey:@"tb_emp_performance"];
        NSArray *array = [emp objectForKey:[status typeStr]];
        
        [self.reportDao batchInsertEmployeePerformance:array type:[status typeStr]];
        
        [records removeAllObjects];
        
        for(NSDictionary *item in array){
            
            NSString *pk = [item objectForKey:@"_id"];
            NSNumber *total = [item objectForKey:@"total"];
            NSString *name = [item objectForKey:@"employee_name"];
            EmployeePerformance *performance = [[EmployeePerformance alloc] initWithPk:pk Total:total Name:name];
            [records addObject:performance];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportEmployeeView *myView = (ReportEmployeeView*)self.view;
            [myView.barView reload];
        });
    }];
}

- (void) handleSwipeLeft
{
    [super handleSwipeLeft];
    
    ReportShopViewController *shop = [[ReportShopViewController alloc] init];
    [self.navigationController pushViewController:shop animated:YES];
}

- (void) handleSwipeRight
{
    [super handleSwipeRight];
}

#pragma mark - BarChart datasource

-(int) totalValue
{
    int sum = 0;
    for(EmployeePerformance *item in records){
        sum += [item.total intValue];
    }
    return sum;
}

-(NSUInteger) rowCount
{
    return [records count];
}

-(int) maxValue
{
    if([records count] == 0){
        return 0;
    }
    
    EmployeePerformance *max = [records firstObject];
    return [max.total intValue];
}

-(NSString*) nameAtIndex:(int)index
{
    EmployeePerformance *item = [records objectAtIndex:index];
    return item.employeeName;
}

-(int) valueAtIndex:(int)index
{
    EmployeePerformance *item = [records objectAtIndex:index];
    return [item.total intValue];
}

@end
