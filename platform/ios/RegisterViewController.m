#import "RegisterViewController.h"
#import "RegisterView.h"
#import "LoginViewController.h"

@implementation RegisterViewController

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
    RegisterView *view = [[RegisterView alloc] initWithController:self Type:self.type];
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
    RegisterView *myView = (RegisterView*)self.view;
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
    RegisterView *myView = (RegisterView*)self.view;
    UITextField *phone = myView.username;
    
    BOOL flag = [self checkPhone:phone.text];
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
    RegisterView *myView = (RegisterView*)self.view;
    
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSString* submitURL;
        if([self.type isEqualToString:@"register"]){
            submitURL = REGISTER_URL;
        }else{
            submitURL = RESET_PASSWORD_URL;
        }
        
        NSString *data = [NSString stringWithFormat:@"username=%@&password=%@", phone, password];
        NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:submitURL Data:postData completionHandler:^(NSDictionary *result){
            
            NSString *msg;
            if([self.type isEqualToString:@"register"]){
                msg = @"注册失败，请联系客服";
            }else{
                msg = @"重设密码失败，请联系客服";
            }
            
            if(result == nil){
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [result objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                LoginViewController *loginVC = (LoginViewController*)self.presentingViewController;
                [loginVC setUserNameAfterRegister:phone];
                [loginVC dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }];
}

#pragma mark - frontend validate

-(BOOL) checkPhone:(NSString*)phone
{
    NSString *phoneRegex = @"^((13)|(15)|(18))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

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
    RegisterView *myView = (RegisterView*)self.view;
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
    RegisterView *myView = (RegisterView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
}

@end
