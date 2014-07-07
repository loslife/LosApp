#import "ReportShopViewController.h"
#import "ReportCustomViewController.h"
#import "BusinessPerformance.h"

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
    [records removeAllObjects];
    
    double total = 4533.0;
    
    double r1 = 1344.0 / total;
    BusinessPerformance *p1 = [[BusinessPerformance alloc] initWithTitle:@"卖品业绩" Value:1344 Ratio:r1];
    p1.increased = YES;
    p1.compareToPrev = 300;
    p1.compareToPrevRatio = (1344 - 300) / 300;
    
    double r2 = 566.0 / total;
    BusinessPerformance *p2 = [[BusinessPerformance alloc] initWithTitle:@"服务业绩" Value:566 Ratio:r2];
    p2.increased = YES;
    p2.compareToPrev = 200;
    p2.compareToPrevRatio = (566 - 200) / 200;
    
    double r3 = 2000.0 / total;
    BusinessPerformance *p3 = [[BusinessPerformance alloc] initWithTitle:@"开卡业绩" Value:2000 Ratio:r3];
    p3.increased = NO;
    p3.compareToPrev = 1000;
    p3.compareToPrevRatio = (2000 - 1000) / 1000;
    
    double r4 = 623.0 / total;
    BusinessPerformance *p4 = [[BusinessPerformance alloc] initWithTitle:@"充值业绩" Value:623 Ratio:r4];
    p4.increased = YES;
    p4.compareToPrev = 500;
    p4.compareToPrevRatio = (623 - 500) / 500;
    
    [records addObject:p1];
    [records addObject:p2];
    [records addObject:p3];
    [records addObject:p4];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ReportShopView *myView = (ReportShopView*)self.view;
        [myView reload];
    });
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
    NSUInteger sum = 0;
    for(BusinessPerformance *item in records){
        sum += item.value;
    }
    return [NSString stringWithFormat:@"￥%ld", sum];
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
