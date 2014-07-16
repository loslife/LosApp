#import "RegisterStep1ViewController.h"
#import "RegisterStep1View.h"
#import "LoginViewController.h"
#import "StringUtils.h"
#import "RegisterOrResetStep2ViewController.h"

@implementation RegisterStep1ViewController

{
    LosHttpHelper *httpHelper;
    
    NSTimer *timer;
    int tick;
    BOOL expired;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
        expired = NO;
    }
    return self;
}

-(void) loadView
{
    RegisterStep1View *view = [[RegisterStep1View alloc] initWithController:self];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    navigationItem.title = @"注册";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = backButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void) back
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
        
        NSString *url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"register_losapp"];
        
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
                [self showSentMessage];
                [self startTick];
            });
        }];
    });
}

-(void) showSentMessage
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UIButton *button = myView.requireCodeButton;
    UILabel *message = myView.sentMessage;
    
    [button removeFromSuperview];
    [myView addSubview:message];
}

-(void) startTick
{
    tick = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    tick--;
    
    if(tick > 0){
        return;
    }
    
    [self tickExpired];
    [timer invalidate];
}

-(void) tickExpired
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    UITextField *code = myView.code;
    UILabel *resentMessage = myView.sentMessage;
    UILabel *expiredMessage = myView.expiredMessage;
    
    [code removeFromSuperview];
    [resentMessage removeFromSuperview];
    [myView addSubview:expiredMessage];
    expired = YES;
}

-(void) submitButtonTapped
{
    RegisterStep1View *myView = (RegisterStep1View*)self.view;
    
    NSString* phone = myView.username.text;
    NSString* code = myView.code.text;
    
    BOOL flag = [self checkInputWithPhone:phone code:code];
    
    if(!flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"输入不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(expired){
        [self doCheckPhone:phone code:@"expired"];
    }else{
        [self doCheckPhone:phone code:code];
    }
}

-(void) doCheckPhone:(NSString*)phone code:(NSString*)code
{
    NSString *checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phone, @"register_losapp", code];
    
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
        
        [self jumpToStep2];
    }];
}

-(void) jumpToStep2
{
    RegisterOrResetStep2ViewController *controller = [[RegisterOrResetStep2ViewController alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:controller animated:YES completion:nil];
    });
}

#pragma mark - frontend validate

-(BOOL) checkInputWithPhone:(NSString*)phone code:(NSString*)code
{
    if(expired){
        return ![StringUtils isEmpty:phone];
    }
    
    if([StringUtils isEmpty:phone] || [StringUtils isEmpty:code]){
        return NO;
    }
    
    return YES;
}

@end
