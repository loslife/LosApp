#import "AppUpdateViewController.h"

@implementation AppUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"版本更新";
    }
    return self;
}

-(void) loadView
{
    AppUpdateView *view = [[AppUpdateView alloc] initWithController:self];
    self.view = view;
}

#pragma mark - delegate

-(void) update
{
    
}

-(BOOL) hasNewVersion
{
    return YES;
}

-(NSArray*) featuresDescription
{
    return nil;
}

@end
