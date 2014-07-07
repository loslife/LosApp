#import "ReportViewControllerBase.h"
#import "ReportDateStatus.h"
#import "UserData.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "StringUtils.h"


@implementation ReportViewControllerBase

-(id) init
{
    self = [super init];
    if(self){
        self.reportDao = [[ReportDao alloc] init];
        self.enterpriseDao = [[EnterpriseDao alloc] init];
    }
    return self;
}

- (void) handleSwipeLeft
{
    [self closeDropdown];
}

- (void) handleSwipeRight
{
    [self closeDropdown];
}

-(void) closeDropdown
{
    SwitchShopButton* barButton = (SwitchShopButton*)self.navigationItem.rightBarButtonItem;
    [barButton closeSwitchShopMenu];
}

-(void) initEnterprises
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if(!currentEnterpriseId){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.title = @"我的店铺";
        });
        return;
    }
    
    NSString *enterpriseName = [self.enterpriseDao queryEnterpriseNameById:currentEnterpriseId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([StringUtils isEmpty:enterpriseName]){
            self.navigationItem.title = @"我的店铺";
        }else{
            self.navigationItem.title = enterpriseName;
        }
    });
}

#pragma mark - delegate

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    [status setDate:date];
    [status setDateType:type];
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
