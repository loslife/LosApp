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
    return 7;
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
    
    LosLineChartItem *item1 = [[LosLineChartItem alloc] initWithTitle:@"09:00" value:8 order:4];
    LosLineChartItem *item2 = [[LosLineChartItem alloc] initWithTitle:@"10:00" value:35 order:1];
    LosLineChartItem *item3 = [[LosLineChartItem alloc] initWithTitle:@"11:00" value:0 order:4];
    LosLineChartItem *item4 = [[LosLineChartItem alloc] initWithTitle:@"12:00" value:14 order:4];
    LosLineChartItem *item5 = [[LosLineChartItem alloc] initWithTitle:@"13:00" value:15 order:3];
    LosLineChartItem *item6 = [[LosLineChartItem alloc] initWithTitle:@"14:00" value:23 order:2];
    LosLineChartItem *item7 = [[LosLineChartItem alloc] initWithTitle:@"15:00" value:0 order:4];
    
    [items addObject:item1];
    [items addObject:item2];
    [items addObject:item3];
    [items addObject:item4];
    [items addObject:item5];
    [items addObject:item6];
    [items addObject:item7];
    
    return [items objectAtIndex:index];
}

@end
