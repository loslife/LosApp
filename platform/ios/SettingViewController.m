#import "SettingViewController.h"

@implementation SettingViewController

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        self.tabBarItem.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting"];
    }
    return self;
}

-(void) loadView
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
    label.text = @"设置";
    label.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:label];
    
    self.view = view;
}

@end
