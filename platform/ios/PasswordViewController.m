#import "PasswordViewController.h"
#import "PasswordView.h"

@implementation PasswordViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"修改密码";
    }
    return self;
}

-(void) loadView
{
    PasswordView *view = [[PasswordView alloc] initWithController:self];
    self.view = view;
}

-(void) modifyPassword
{
    NSLog(@"modify password");
}

@end
