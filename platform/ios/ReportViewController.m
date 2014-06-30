#import "ReportViewController.h"
#import "ReportView.h"
#import "LosDao.h"
#import "UserData.h"

@implementation ReportViewController

{
    LosDao *dao;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        dao = [[LosDao alloc] init];
        
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        
        self.navigationItem.title = @"一家好店";
        
        self.tabBarItem.title = @"经营";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_report"];
    }
    return self;
}

-(void) loadView
{
    ReportView *view = [[ReportView alloc] initWithController:self];
    self.view = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
    
    NSArray *records = [dao queryEmployeePerformanceByDate:date EnterpriseId:currentEnterpriseId Type:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger count = [records count];
        NSLog(@"%lu", (unsigned long)count);
    });
}

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    NSLog(@"date picked");
}

#pragma mark - SwitchShopButtonDelegate

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    NSLog(@"enterprise switch");
}

@end
