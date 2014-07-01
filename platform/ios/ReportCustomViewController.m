#import "ReportCustomViewController.h"
#import "ReportCustomView.h"

@implementation ReportCustomViewController

-(id) init
{
    self = [super init];
    if(self){
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
        self.navigationItem.title = @"一家好店";
    }
    return self;
}

-(void) loadView
{
    ReportCustomView *view = [[ReportCustomView alloc] initWithController:self];
    self.view = view;
}

#pragma mark - abstract method implementation

-(void) dateSelected:(NSDate*)date Type:(DateDisplayType)type
{
    [super dateSelected:date Type:type];
    NSLog(@"custom date picked");
}

-(void) enterpriseSelected:(NSString*)enterpriseId
{
    NSLog(@"enterprise switch");
}

- (void) handleSwipeLeft
{
    
}

- (void) handleSwipeRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
