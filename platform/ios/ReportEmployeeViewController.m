#import "ReportEmployeeViewController.h"
#import "ReportEmployeeView.h"
#import "LosDao.h"
#import "UserData.h"
#import "ReportCustomViewController.h"

@implementation ReportEmployeeViewController

-(id) init
{
    self = [super init];
    if(self){
        
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
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setYear:2014];
    [components setMonth:6];
    [components setDay:26];
    
    NSCalendar *current = [NSCalendar currentCalendar];
    NSDate* date = [current dateFromComponents:components];
    
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    NSArray *records = [self.dao queryEmployeePerformanceByDate:date EnterpriseId:currentEnterpriseId Type:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger count = [records count];
        NSLog(@"%lu", (unsigned long)count);
    });
}

#pragma mark - abstract method implementation

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    [super dateSelected:date Type:type];
    NSLog(@"employee date picked");
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    NSLog(@"enterprise switch");
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
}

@end
