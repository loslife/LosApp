#import "ReportServiceViewController.h"
#import "ReportServiceView.h"
#import "ReportCustomViewController.h"
#import "ServicePerformance.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"

@implementation ReportServiceViewController

{
    NSMutableArray *records;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        records = [NSMutableArray array];
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    ReportServiceView *view = [[ReportServiceView alloc] initWithController:self];
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
        
        records = [self.reportDao queryServicePerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportServiceView *myView = (ReportServiceView*)self.view;
            [myView reload];
        });
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"service"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *services = [current objectForKey:@"tb_service_performance"];
        NSArray *array = [services objectForKey:[status typeStr]];
        
        [self.reportDao batchInsertServicePerformance:array type:[status typeStr]];
        
        [records removeAllObjects];
        
        double sum = 0.0;
        
        for(NSDictionary *item in array){
            
            NSString *title = [item objectForKey:@"project_name"];
            double total = [[item objectForKey:@"total"] doubleValue];
            sum += total;
            ServicePerformance *performance = [[ServicePerformance alloc] initWithTitle:title value:total];
            [records addObject:performance];
        }
        
        for(ServicePerformance *item in records){
            item.ratio = item.value / sum;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportServiceView *myView = (ReportServiceView*)self.view;
            [myView reload];
        });
    }];
}

- (void) handleSwipeLeft
{
    [super handleSwipeLeft];
    
    ReportCustomViewController *custom = [[ReportCustomViewController alloc] init];
    [self.navigationController pushViewController:custom animated:YES];
}

- (void) handleSwipeRight
{
    [super handleSwipeRight];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Service View DataSource

-(NSString*) total
{
    double sum = 0;
    for(ServicePerformance *item in records){
        sum += item.value;
    }
    return [NSString stringWithFormat:@"￥%f", sum];
}

-(NSUInteger) itemCount
{
    NSUInteger count = [records count];
    if(count > 3){
        return count - 3;
    }
    return 0;
}

-(ServicePerformance*) itemAtIndex:(int)index
{
    return [records objectAtIndex:index + 3];
}

#pragma mark - PieChart delegate

-(NSUInteger) pieItemCount
{
    if([records count] <= 4){
        return [records count];
    }
    return 4;
}

-(LosPieChartItem*) pieItemAtIndex:(int)index
{
    if(index < 3){
        ServicePerformance *performance = [records objectAtIndex:index];
        NSString *title = [NSString stringWithFormat:@"%d.%@ %f", index + 1, performance.title, performance.ratio];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:performance.ratio];
    }
    
    double sum = 0.0;
    
    for(int i = 3; i < [records count]; i++){
        ServicePerformance *performance = [records objectAtIndex:i];
        sum += performance.ratio;
    }
    NSString *title = [NSString stringWithFormat:@"其他 %f", sum];
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
