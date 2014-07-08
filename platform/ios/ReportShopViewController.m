#import "ReportShopViewController.h"
#import "ReportCustomViewController.h"
#import "BusinessPerformance.h"
#import "ReportDateStatus.h"
#import "UserData.h"
#import "StringUtils.h"

@implementation ReportShopViewController

{
    NSMutableArray *records;
}

-(id) init
{
    self = [super init];
    if(self){
        
        records = [NSMutableArray array];
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    ReportShopView *view = [[ReportShopView alloc] initWithController:self];
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
        
        records = [self.reportDao queryBusinessPerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportShopView *myView = (ReportShopView*)self.view;
            [myView reload];
        });
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"business"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *biz = [current objectForKey:@"tb_biz_performance"];
        NSDictionary *record = [biz objectForKey:[status typeStr]];
        
        NSDictionary *prev = [result objectForKey:@"prev"];
        NSDictionary *biz2 = [prev objectForKey:@"tb_biz_performance"];
        NSDictionary *record2 = [biz2 objectForKey:[status typeStr]];
        
        [records removeAllObjects];
        
        if(![record objectForKey:@"_id"]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ReportShopView *myView = (ReportShopView*)self.view;
                [myView reload];
            });
            return;
        }
        
        [self.reportDao insertBusinessPerformance:record type:[status typeStr]];
        
        double total = [[record objectForKey:@"total"] doubleValue];
        double service = [[record objectForKey:@"service"] doubleValue];
        double product = [[record objectForKey:@"product"] doubleValue];
        double newcard = [[record objectForKey:@"newcard"] doubleValue];
        double recharge = [[record objectForKey:@"recharge"] doubleValue];
        
        BusinessPerformance *p1 = [[BusinessPerformance alloc] initWithTitle:@"服务业绩" Value:service Ratio:service / total];
        BusinessPerformance *p2 = [[BusinessPerformance alloc] initWithTitle:@"卖品业绩" Value:product Ratio:product / total];
        BusinessPerformance *p3 = [[BusinessPerformance alloc] initWithTitle:@"开卡业绩" Value:newcard Ratio:newcard / total];
        BusinessPerformance *p4 = [[BusinessPerformance alloc] initWithTitle:@"充值业绩" Value:recharge Ratio:recharge / total];
        
        if([record2 objectForKey:@"_id"]){
            
            double service_prev = [[record2 objectForKey:@"service"] doubleValue];
            double product_prev = [[record2 objectForKey:@"product"] doubleValue];
            double newcard_prev = [[record2 objectForKey:@"newcard"] doubleValue];
            double recharge_prev = [[record2 objectForKey:@"recharge"] doubleValue];
            
            [self assembleCompare:p1 currentValue:service prevValue:service_prev];
            [self assembleCompare:p2 currentValue:product prevValue:product_prev];
            [self assembleCompare:p3 currentValue:newcard prevValue:newcard_prev];
            [self assembleCompare:p4 currentValue:recharge prevValue:recharge_prev];
            
            [self.reportDao insertBusinessPerformance:record2 type:[status typeStr]];
        }
        
        [records addObject:p1];
        [records addObject:p2];
        [records addObject:p3];
        [records addObject:p4];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportShopView *myView = (ReportShopView*)self.view;
            [myView reload];
        });
    }];
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

#pragma mark - abstract method implementation

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    [super dateSelected:date Type:type];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadReport];
    });
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self loadReport];
    });
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

#pragma mark - ReportShopView datasource

-(NSString*) total
{
    double sum = 0;
    for(BusinessPerformance *item in records){
        sum += item.value;
    }
    return [NSString stringWithFormat:@"￥%f", sum];
}

-(NSUInteger) itemCount
{
    return [records count];
}

-(BusinessPerformance*) itemAtIndex:(int)index
{
    return [records objectAtIndex:index];
}

#pragma mark - PieChart delegate

-(LosPieChartItem*) pieItemAtIndex:(int)index
{
    BusinessPerformance *performance = [records objectAtIndex:index];
    
    NSString *title = [NSString stringWithFormat:@"%@%f", performance.title, performance.ratio];
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
        return [UIColor colorWithRed:85/255.0f green:214/255.0f blue:255/255.0f alpha:1.0f];
    }else{
        return [UIColor colorWithRed:134/255.0f green:121/255.0f blue:201/255.0f alpha:1.0f];
    }
}

@end
