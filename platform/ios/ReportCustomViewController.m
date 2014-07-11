#import "ReportCustomViewController.h"
#import "ReportCustomView.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"
#import "CustomerCount.h"

@implementation ReportCustomViewController

{
    NSMutableArray *records;
    NSMutableArray *top3;
}

-(id) init
{
    self = [super init];
    if(self){
        
        records = [NSMutableArray arrayWithCapacity:1];
        top3 = [NSMutableArray arrayWithCapacity:1];
        
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
    [top3 removeAllObjects];
    
    CustomerCount *entity1 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:0 title:@"09:00"];
    CustomerCount *entity2 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:5 title:@"10:00"];
    CustomerCount *entity3 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:12 title:@"11:00"];
    CustomerCount *entity4 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:32 title:@"12:00"];
    CustomerCount *entity5 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:7 title:@"13:00"];
    CustomerCount *entity6 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:12 title:@"14:00"];
    CustomerCount *entity7 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:13 title:@"15:00"];
    CustomerCount *entity8 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:0 title:@"16:00"];
    CustomerCount *entity9 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:8 title:@"17:00"];
    CustomerCount *entity10 = [[CustomerCount alloc] initWithTotalMember:5 walkin:23 count:7 title:@"18:00"];
    
    [records addObject:entity1];
    [records addObject:entity2];
    [records addObject:entity3];
    [records addObject:entity4];
    [records addObject:entity5];
    [records addObject:entity6];
    [records addObject:entity7];
    [records addObject:entity8];
    [records addObject:entity9];
    [records addObject:entity10];
    
    [top3 addObject:[NSNumber numberWithInt:32]];
    [top3 addObject:[NSNumber numberWithInt:13]];
    [top3 addObject:[NSNumber numberWithInt:12]];
    
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
    CustomerCount *entity = [records firstObject];
    return entity.totalMember;
}

-(NSUInteger) walkinCount
{
    CustomerCount *entity = [records firstObject];
    return entity.totalWalkin;
}

#pragma mark - line chart datasource

-(NSUInteger) valuePerSection
{
    double max = 0.0;
    
    for(CustomerCount *entity in records){
        if(entity.count > max){
            max = entity.count;
        }
    }
    
    return ceil(max / 5);
}

-(NSUInteger) itemCount
{
    return [records count];
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    CustomerCount *entity = [records objectAtIndex:index];
    
    int order = 4;
    
    if(entity.count == [[top3 firstObject] intValue]){
        order = 1;
    }else if(entity.count == [[top3 objectAtIndex:1] intValue]){
        order = 2;
    }else if(entity.count == [[top3 objectAtIndex:2] intValue]){
        order = 3;
    }
    
    LosLineChartItem *item = [[LosLineChartItem alloc] initWithTitle:entity.title value:entity.count order:order];
    return item;
}

@end
