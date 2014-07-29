#import "ResetStep1ViewController.h"
#import "LosHttpHelper.h"
#import "ResetStep1View.h"
#import "StringUtils.h"
#import "LosAppUrls.h"
#import "RegisterOrResetStep2ViewController.h"

@implementation ResetStep1ViewController

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
    ResetStep1View *view = [[ResetStep1View alloc] initWithController:self];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    navigationItem.title = @"重设密码";
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
    ResetStep1View *myView = (ResetStep1View*)self.view;
    UITextField *phone = myView.username;
    
    myView.requireCodeButton.enabled = NO;
    
    BOOL flag = [StringUtils isPhone:phone.text];
    if(!flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        myView.requireCodeButton.enabled = YES;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                myView.requireCodeButton.enabled = YES;
            });
            return;
        }
        
        NSString *url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"reset_password_losapp"];
        
        [httpHelper getSecure:url completionHandler:^(NSDictionary *dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    myView.requireCodeButton.enabled = YES;
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    myView.requireCodeButton.enabled = YES;
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startTick];
            });
        }];
    });
}

-(void) submitButtonTapped
{
    ResetStep1View *myView = (ResetStep1View*)self.view;
    
    NSString* phone = myView.username.text;
    NSString* code = myView.code.text;
    
    myView.submit.enabled = NO;
    
    BOOL flag = [self checkInputWithPhone:phone code:code];
    
    if(!flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"手机号和验证码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        myView.submit.enabled = YES;
        return;
    }
    
    [self doCheckPhone:phone code:code];
}

-(void) doCheckPhone:(NSString*)phone code:(NSString*)code
{
    ResetStep1View *myView = (ResetStep1View*)self.view;
    
    NSString *checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phone, @"reset_password_losapp", code];
    
    [httpHelper getSecure:checkCodeURL completionHandler:^(NSDictionary *dict){
        
        if(dict == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                myView.submit.enabled = YES;
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
                    myView.submit.enabled = YES;
                    return;
                }
                
                if([errorCode isEqualToString:@"88888502"]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    myView.submit.enabled = YES;
                    return;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                myView.submit.enabled = YES;
            });
            return;
        }
        
        [self jumpToStep2];
    }];
}

-(void) jumpToStep2
{
    ResetStep1View *myView = (ResetStep1View*)self.view;
    NSString* phone = myView.username.text;
    
    RegisterOrResetStep2ViewController *controller = [[RegisterOrResetStep2ViewController alloc] init];
    controller.type = @"reset";
    controller.phone = phone;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:controller animated:YES completion:nil];
    });
}

#pragma mark - frontend validate

-(BOOL) checkInputWithPhone:(NSString*)phone code:(NSString*)code
{
    if([StringUtils isEmpty:phone] || [StringUtils isEmpty:code]){
        return NO;
    }
    
    return YES;
}

#pragma mark - timer

-(void) startTick
{
    resendCountdown = 90;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        
        ResetStep1View *myView = (ResetStep1View*)self.view;
        UIButton *button = myView.requireCodeButton;
        
        NSString *title = [NSString stringWithFormat:@"%d秒可重发", resendCountdown];
        button.titleLabel.text = title;
        
        return;
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

-(void) enableRequireCodeButton
{
    ResetStep1View *myView = (ResetStep1View*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.titleLabel.text = @"获取验证码";
}

@end
