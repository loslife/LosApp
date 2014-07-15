#import "RegisterStep1ViewController.h"
#import "RegisterStep1View.h"
#import "LoginViewController.h"
#import "StringUtils.h"

@implementation RegisterStep1ViewController

{
    NSTimer *timer;
    int resendCountdown;
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
    RegisterStep1View *view = [[RegisterStep1View alloc] initWithController:self Type:self.type];
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

-(void) viewDidAppear:(BOOL)animated
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    if(button.enabled){
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

#pragma mark - responder

-(void) backToLogin
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) requireVerificationCode
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UITextField *phone = myView.username;
    
    BOOL flag = [StringUtils isPhone:phone.text];
    if(!flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSString *url;
        
        if([self.type isEqualToString:@"register"]){
            url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"register_losapp"];
        }else{
            url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"reset_password_losapp"];
        }
        
        [httpHelper getSecure:url completionHandler:^(NSDictionary *dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableRequireCodeButton];
                [self startTick];
            });
        }];
    });
}

-(void) submitButtonTapped
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    
    NSString* phone = myView.username.text;
    NSString* code = myView.code.text;
    NSString* password = myView.password.text;
    NSString* repeat = myView.passwordRepeat.text;
    
    int flag = [self checkInputWithPhone:phone Code:code Password:password Repeat:repeat];
    
    if(flag != 0){
        if(flag == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码和验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        if(flag == 2){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码输入不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        if(flag == 3){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码长度错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    
    [self doCheckPhone:phone Code:code Password:password];
}

-(void) doCheckPhone:(NSString*)phone Code:(NSString*)code Password:(NSString*)password
{
    NSString *checkCodeURL;
    if([self.type isEqualToString:@"register"]){
        checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phone, @"register_losapp", code];
    }else{
        checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phone, @"reset_password_losapp", code];
    }
    
    [httpHelper getSecure:checkCodeURL completionHandler:^(NSDictionary *dict){
        
        if(dict == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSNumber *code = [dict objectForKey:@"code"];
        if([code intValue] != 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *result = [dict objectForKey:@"result"];
                NSString *errorCode = [result objectForKey:@"errorCode"];
                
                if([errorCode isEqualToString:@"88888501"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码已失效，请重新获取" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                if([errorCode isEqualToString:@"88888502"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        [self doSubmit:phone Password:password];
    }];
}

-(void) doSubmit:(NSString*)phone Password:(NSString*)password
{
    NSString* submitURL;
    if([self.type isEqualToString:@"register"]){
        submitURL = REGISTER_URL;
    }else{
        submitURL = RESET_PASSWORD_URL;
    }
    
    NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", phone, password];
    NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    [httpHelper postSecure:submitURL Data:postData completionHandler:^(NSDictionary *result){
        
        if(result == nil){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"服务器出错，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSNumber *code = [result objectForKey:@"code"];
        if([code intValue] != 0){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                NSDictionary *inner = [result objectForKey:@"result"];
                NSString *errorCode = [inner objectForKey:@"errorCode"];

                if([self.type isEqualToString:@"register"]){
                    
                    if([errorCode isEqualToString:@"500"]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号已被注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"错误码：%@", errorCode] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }
                }else{
                    if([errorCode isEqualToString:@"501"]){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"错误码：%@", errorCode] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }
                }
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
            [loginVC dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark - frontend validate

-(int) checkInputWithPhone:(NSString*)phone Code:(NSString*)code Password:(NSString*)password Repeat:(NSString*)repeat
{
    if([StringUtils isEmpty:phone] || [StringUtils isEmpty:code] || [StringUtils isEmpty:password] || [StringUtils isEmpty:repeat]){
        return 1;
    }
    
    if(![password isEqualToString:repeat]){
        return 2;
    }
    
    if(password.length < 6 || password.length > 16){
        return 3;
    }
    
    return 0;
}

#pragma mark - timer

-(void) disableRequireCodeButton
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = NO;
    button.backgroundColor = [UIColor whiteColor];
}

-(void) startTick
{
    resendCountdown = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        return;
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

-(void) enableRequireCodeButton
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
}

@end
