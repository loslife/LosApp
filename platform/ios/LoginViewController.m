#import "LoginViewController.h"
#import "LoginView.h"

@implementation LoginViewController

{
    LosHttpHelper *httpHelper;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

-(void) loadView
{
    LoginView *view = [[LoginView alloc] initWithController:self];
    self.view = view;
}

-(void) setUserNameAfterRegister:(NSString*)phoneNumber
{
    LoginView* theView = (LoginView*)self.view;
    theView.username.text = phoneNumber;
}

-(void) loginButtonPressed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL flag = [LosHttpHelper isNetworkAvailable];
        if(!flag){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"无网络连接，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        LoginView *myView = (LoginView*)self.view;
        NSString *userName = myView.username.text;
        NSString *password = myView.password.text;
        
        NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", userName, password];
        NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:LOGIN_URL Data:postData completionHandler:^(NSDictionary *dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登陆失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            NSDictionary *result = [dict objectForKey:@"result"];
            
            if([code intValue] != 0){
                
                NSString *errorCode = [result objectForKey:@"errorCode"];
                if([errorCode isEqualToString:@"401"]){
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    });
                    return;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登陆失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            [UserData writeUserId:userName];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                BootstrapViewController *bootstrap = [[BootstrapViewController alloc] init];
                [self presentViewController:bootstrap animated:YES completion:nil];
            });
        }];
    });
}

-(void) registerButtonPressed
{
    RegisterStepOneViewController *registerStep1 = [[RegisterStepOneViewController alloc] init];
    registerStep1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:registerStep1 animated:YES completion:nil];
}

@end
