#import "ReportEmployeeViewController.h"
#import "ReportEmployeeView.h"
#import "LosDao.h"
#import "UserData.h"
#import "ReportCustomViewController.h"
#import "ReportDateStatus.h"
#import "StringUtils.h"

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
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([StringUtils isEmpty:currentEnterpriseId]){
        return;
    }
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    NSArray *records = [self.dao queryEmployeePerformanceByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger count = [records count];
        NSString *message = [NSString stringWithFormat:@"%lu条记录", count];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark - abstract method implementation

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    [super dateSelected:date Type:type];
    [self loadReport];
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    [self loadReport];
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
