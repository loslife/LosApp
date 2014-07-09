#import "ReportServiceViewController.h"
#import "ReportServiceView.h"
#import "ReportCustomViewController.h"
#import "ServicePerformance.h"

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
    [records removeAllObjects];
    
    double total = 9999;
    
    ServicePerformance *p1 = [[ServicePerformance alloc] initWithTitle:@"修手" Value:888 Ratio:888 / total];
    ServicePerformance *p2 = [[ServicePerformance alloc] initWithTitle:@"做脚" Value:2999 Ratio:2999 / 9999];
    ServicePerformance *p3 = [[ServicePerformance alloc] initWithTitle:@"修眉" Value:1112 Ratio:1112 / 9999];
    ServicePerformance *p4 = [[ServicePerformance alloc] initWithTitle:@"剪头发" Value:1000 Ratio:1000 / 9999];
    ServicePerformance *p5 = [[ServicePerformance alloc] initWithTitle:@"洗剪吹" Value:1000 Ratio:1000 / 9999];
    ServicePerformance *p6 = [[ServicePerformance alloc] initWithTitle:@"按摩" Value:2000 Ratio:2000 / 9999];
    ServicePerformance *p7 = [[ServicePerformance alloc] initWithTitle:@"泡澡" Value:1000 Ratio:1000 / 9999];
    
    [records addObject:p1];
    [records addObject:p2];
    [records addObject:p3];
    [records addObject:p4];
    [records addObject:p5];
    [records addObject:p6];
    [records addObject:p7];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ReportServiceView *myView = (ReportServiceView*)self.view;
        [myView reload];
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
        NSString *title = [NSString stringWithFormat:@"%d.%@%f", index + 1, performance.title, performance.ratio];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:performance.ratio];
    }
    
    double sum = 0.0;
    
    for(int i = 3; i < [records count]; i++){
        ServicePerformance *performance = [records objectAtIndex:i];
        sum += performance.ratio;
    }
    return [[LosPieChartItem alloc] initWithTitle:@"其他" Ratio:sum];
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
