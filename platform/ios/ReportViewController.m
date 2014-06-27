#import "ReportViewController.h"
#import "ReportView.h"

@implementation ReportViewController

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        UIButton *switchShop = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [switchShop setBackgroundImage:[UIImage imageNamed:@"switch_shop"] forState:UIControlStateNormal];
        [switchShop addTarget:self action:@selector(switchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switchShop];
        
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
}

-(void) switchButtonTapped
{
    NSLog(@"hehe");
}

-(void) dateSelected:(NSDate*)date
{
    NSLog(@"date picked");
}

@end
