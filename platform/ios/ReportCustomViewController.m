#import "ReportCustomViewController.h"
#import "ReportCustomView.h"

@implementation ReportCustomViewController

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
    ReportCustomView *view = [[ReportCustomView alloc] initWithController:self];
    self.view = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [super initEnterprises];
        [self loadReport];
    });
}

-(void) loadReport
{
    NSLog(@"hehe");
}

#pragma mark - abstract method implementation

- (void) handleSwipeLeft
{
    [super handleSwipeLeft];
}

- (void) handleSwipeRight
{
    [super handleSwipeRight];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - line chart datasource

-(NSUInteger) valuePerSection
{
    return 7;
}

-(NSUInteger) itemCount
{
    return 6;
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
    
    LosLineChartItem *item1 = [[LosLineChartItem alloc] initWithTitle:@"1" value:8];
    LosLineChartItem *item2 = [[LosLineChartItem alloc] initWithTitle:@"2" value:35];
    LosLineChartItem *item3 = [[LosLineChartItem alloc] initWithTitle:@"3" value:0];
    LosLineChartItem *item4 = [[LosLineChartItem alloc] initWithTitle:@"4" value:14];
    LosLineChartItem *item5 = [[LosLineChartItem alloc] initWithTitle:@"5" value:15];
    LosLineChartItem *item6 = [[LosLineChartItem alloc] initWithTitle:@"6" value:23];
    
    [items addObject:item1];
    [items addObject:item2];
    [items addObject:item3];
    [items addObject:item4];
    [items addObject:item5];
    [items addObject:item6];
    
    return [items objectAtIndex:index];
}

@end
