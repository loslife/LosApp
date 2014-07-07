#import "ReportShopViewController.h"
#import "ReportShopView.h"
#import "ReportCustomViewController.h"

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
    
    LosPieChartItem *item1 = [[LosPieChartItem alloc] initWithTitle:@"卖品业绩28%" Ratio:0.28];
    LosPieChartItem *item2 = [[LosPieChartItem alloc] initWithTitle:@"充值业绩9.8%" Ratio:0.10];
    LosPieChartItem *item3 = [[LosPieChartItem alloc] initWithTitle:@"开卡业绩14.2%" Ratio:0.14];
    LosPieChartItem *item4 = [[LosPieChartItem alloc] initWithTitle:@"服务业绩48%" Ratio:0.48];
    [records addObject:item1];
    [records addObject:item2];
    [records addObject:item3];
    [records addObject:item4];
    
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

#pragma mark - PieChart delegate

-(NSUInteger) itemCount
{
    return [records count];
}

-(LosPieChartItem*) itemAtIndex:(int)index
{
    return [records objectAtIndex:index];
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
