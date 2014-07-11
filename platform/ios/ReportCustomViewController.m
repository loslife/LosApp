#import "ReportCustomViewController.h"
#import "ReportCustomView.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"

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
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([StringUtils isEmpty:currentEnterpriseId]){
        return;
    }
    
    //ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    [records removeAllObjects];
    
    LosLineChartItem *item1 = [[LosLineChartItem alloc] initWithTitle:@"09:00" value:8 order:4];
    LosLineChartItem *item2 = [[LosLineChartItem alloc] initWithTitle:@"10:00" value:35 order:1];
    LosLineChartItem *item3 = [[LosLineChartItem alloc] initWithTitle:@"11:00" value:0 order:4];
    LosLineChartItem *item4 = [[LosLineChartItem alloc] initWithTitle:@"12:00" value:14 order:4];
    LosLineChartItem *item5 = [[LosLineChartItem alloc] initWithTitle:@"13:00" value:15 order:3];
    LosLineChartItem *item6 = [[LosLineChartItem alloc] initWithTitle:@"14:00" value:23 order:2];
    LosLineChartItem *item7 = [[LosLineChartItem alloc] initWithTitle:@"15:00" value:0 order:4];
    
    [records addObject:item1];
    [records addObject:item2];
    [records addObject:item3];
    [records addObject:item4];
    [records addObject:item5];
    [records addObject:item6];
    [records addObject:item7];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ReportCustomView *myView = (ReportCustomView*)self.view;
        [myView reload];
    });
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

#pragma mark - customer view datasource

-(NSUInteger) memberCount
{
    return 5;
}

-(NSUInteger) walkinCount
{
    return 23;
}

#pragma mark - line chart datasource

-(NSUInteger) valuePerSection
{
    return 7;
}

-(NSUInteger) itemCount
{
    return [records count];
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    return [records objectAtIndex:index];
}

@end
