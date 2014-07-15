#import "RegisterStep2ViewController.h"
#import "RegisterStep2View.h"

@implementation RegisterStep2ViewController

-(void) loadView
{
    RegisterStep2View *view = [[RegisterStep2View alloc] initWithController:self Type:self.type];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if([self.type isEqualToString:@"register"]){
        navigationItem.title = @"注册";
    }else{
        navigationItem.title = @"重设密码";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = backButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
}

-(void) back
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
