#import "ReportViewControllerBase.h"
#import "ReportDateStatus.h"

@implementation ReportViewControllerBase

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
