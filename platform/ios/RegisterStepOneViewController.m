#import "RegisterStepOneViewController.h"
#import "RegisterStepOneView.h"

@implementation RegisterStepOneViewController

-(void) loadView
{
    RegisterStepOneView *view = [[RegisterStepOneView alloc] initWithController:self];
    self.view = view;
}

-(void) closeButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) registerButtonPressed
{
    RegisterStepOneView *myView = (RegisterStepOneView*)self.view;
    NSString *userName = myView.username.text;
    NSString *password = myView.password.text;
    
    BOOL validate = [self checkUserName:userName Password:password];
    
}

#pragma mark - private method

-(BOOL) checkUserName:(NSString*)userName Password:(NSString*)password
{
    // 不为空校验
    if(!userName || userName.length == 0 || !password || password.length == 0){
        return NO;
    }
    
    // 手机号校验
    NSString *phoneRegex = @"^((13)|(15)|(18))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:userName];
}

@end
