#import "ReportViewController.h"
#import "ReportView.h"
#import "UserData.h"
#import "StringUtils.h"
#import "EnterpriseDao.h"
#import "LosHttpHelper.h"
#import "ReportDateStatus.h"
#import "NoShopView.h"

@implementation ReportViewController

{
    NSString *previousEnterpriseId;
    NSString *currentEnterpriseId;
    
    EnterpriseDao *enterpriseDao;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        enterpriseDao = [[EnterpriseDao alloc] init];
        
        self.employeeDataSource = [[ReportEmployeeDataSource alloc] init];
        self.shopDataSource = [[ReportShopDataSource alloc] init];
        self.serviceDataSource = [[ReportServiceDataSource alloc] init];
        self.customDataSource = [[ReportCustomDataSource alloc] init];
        
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        
        self.tabBarItem.title = @"经营";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_report"];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    UserData *userData = [UserData load];
    currentEnterpriseId = userData.enterpriseId;
    
    // 无关联店铺
    if([StringUtils isEmpty:currentEnterpriseId]){
        
        if(![StringUtils isEmpty:previousEnterpriseId]){
            previousEnterpriseId = nil;
        }
        
        NoShopView *noShop = [[NoShopView alloc] initWithFrame:CGRectMake(0, 64, 320, 455)];
        self.view = noShop;
        
        self.navigationItem.title = @"我的店铺";
        
        return;
    }
    
    // 未切换店铺
    if([previousEnterpriseId isEqualToString:currentEnterpriseId]){
        return;
    }
    
    // 以下是切换了店铺的处理
    previousEnterpriseId = currentEnterpriseId;
    
    [self resolveNavTitle];
    [self loadReport];
}

-(void) resolveNavTitle
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *enterpriseName = [enterpriseDao queryEnterpriseNameById:currentEnterpriseId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([StringUtils isEmpty:enterpriseName]){
                self.navigationItem.title = @"我的店铺";
            }else{
                self.navigationItem.title = enterpriseName;
            }
        });
    });
}

// invoked in main thread
-(void) loadReport
{
    if(![self.view isKindOfClass:[ReportView class]]){
        
        ReportView *view = [[ReportView alloc] initWithController:self];
        self.view = view;
    }
    
    ReportView *myView = (ReportView*)self.view;
    [myView showLoading];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL flag = [LosHttpHelper isNetworkAvailable];
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [self.employeeDataSource loadFromServer:flag block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self.shopDataSource loadFromServer:flag block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self.serviceDataSource loadFromServer:flag block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self.customDataSource loadFromServer:flag block:^(BOOL flag){
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [myView reloadAndShowData];
        });
    });
}

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    [status setDate:date];
    [status setDateType:type];
    
    [self loadReport];
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    UserData *userData = [UserData load];
    currentEnterpriseId = userData.enterpriseId;
    previousEnterpriseId = currentEnterpriseId;
    
    [self loadReport];
}

-(void) onSingleTap
{
    SwitchShopButton* barButton = (SwitchShopButton*)self.navigationItem.rightBarButtonItem;
    [barButton closeSwitchShopMenu];
}

@end
