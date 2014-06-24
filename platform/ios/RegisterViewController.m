#import "RegisterViewController.h"
#import "RegisterView.h"
#import "LoginViewController.h"

@implementation RegisterViewController

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
    RegisterView *view = [[RegisterView alloc] initWithController:self];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];

    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if([self.type isEqualToString:@"register"]){
        navigationItem.title = @"注册";
    }else{
        navigationItem.title = @"重设密码";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(backToLogin)];
    navigationItem.leftBarButtonItem = backButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
}

-(void) backToLogin
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) requireVerificationCode
{
    NSLog(@"hehe");
}

-(void) registerButtonPressed
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
        
        RegisterView *myView = (RegisterView*)self.view;
        NSString *userName = myView.username.text;
        NSString *password = myView.password.text;
        
        BOOL validate = [self checkUserName:userName Password:password];
        if(!validate){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", userName, password];
        NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:REGISTER_URL Data:postData completionHandler:^(NSDictionary *result){
        
            if(result == nil){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            // server logic error
            NSNumber *code = [result objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
                [loginVC setUserNameAfterRegister:userName];
                [loginVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    });
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
