#import "AddShopViewController.h"
#import "AddShopView.h"
#import "StringUtils.h"
#import "EnterpriseDao.h"
#import "UserData.h"

#define CONFIRM_RE_ATTACH 24
#define CONFIRM_UNDO_ATTACH 25

@implementation AddShopViewController

{
    NSTimer *timer;
    int resendCountdown;
    
    LosHttpHelper *httpHelper;
    EnterpriseDao *dao;
    
    NSString *enterpriseIdInProcess;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.navigationItem.title = @"关联店铺";
        
        httpHelper = [[LosHttpHelper alloc] init];
        dao = [[EnterpriseDao alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void) loadView
{
    AddShopView *view = [[AddShopView alloc] initWithController:self];
    self.view = view;
    
    [view.list reload];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void) requireVerificationCode
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    
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
        
        NSString *url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"attach"];
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

-(void) appendEnterprise:(void(^)())block
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phoneField = myView.phone;
    UITextField *codeField = myView.code;
    
    int validate = [self frontendValidateWithPhone:phoneField.text code:codeField.text];
    
    if(validate == 1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        block();
        return;
    }
    
    if(validate == 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        block();
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                block();
            });
            return;
        }
        
        NSString *checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phoneField.text, @"attach", codeField.text];
        
        [httpHelper getSecure:checkCodeURL completionHandler:^(NSDictionary *dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    block();
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    block();
                });
                return;
            }
            
            UserData *userData = [UserData load];
            NSString *userId = userData.userId;
            
            NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_account=%@", userId, phoneField.text];
            NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
            
            [httpHelper postSecure:APPEND_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
                
                if(dict == nil){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                        [alert show];
                        block();
                    });
                    return;
                }
                
                NSNumber *code = [dict objectForKey:@"code"];
                NSDictionary *result = [dict objectForKey:@"result"];
                
                if([code intValue] != 0){
                    
                    NSString *errorCode = [result objectForKey:@"errorCode"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if([errorCode isEqualToString:@"501"]){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"美管家账号不存在" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                            [alert show];
                            block();
                        }else if([errorCode isEqualToString:@"502"]){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"美管家版本太低，请升级美管家版本" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                            [alert show];
                            block();
                        }else if([errorCode isEqualToString:@"503"]){
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"此美管家账号已被关联，重启应用可见" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                            [alert show];
                            block();
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                            [alert show];
                            block();
                        }
                    });
                    
                    return;
                }
                
                NSString *enterpriseId = [result objectForKey:@"enterprise_id"];
                NSString *enterpriseName = [result objectForKey:@"enterprise_name"];
                [dao insertEnterprisesWith:enterpriseId Name:enterpriseName account:phoneField.text];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    
                    [self clearFormAfterAppend];
                    
                    [myView.list reload];
                    
                    if([StringUtils isEmpty:userData.enterpriseId]){
                        [UserData writeCurrentEnterprise:enterpriseId];
                    }
                    
                    block();
                });
            }];
        }];
    });
}

-(int) frontendValidateWithPhone:(NSString*)phone code:(NSString*)code
{
    if(![StringUtils isPhone:phone]){
        return 1;
    }
    
    if([StringUtils isEmpty:code]){
        return 2;
    }
    
    return 0;
}

-(void) clearFormAfterAppend
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phoneField = myView.phone;
    UITextField *codeField = myView.code;
    
    [myView fold];
    
    phoneField.text = @"";
    codeField.text = @"";
    
    if([phoneField isFirstResponder]){
        [phoneField resignFirstResponder];
    }
    if([codeField isFirstResponder]){
        [codeField resignFirstResponder];
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

#pragma mark - delegate

-(void) reAttach:(NSString*)enterpriseId name:(NSString*)enterpriseName
{
    NSString* message = [NSString stringWithFormat:@"恢复对'%@'的关联？", enterpriseName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = CONFIRM_RE_ATTACH;
    [alert show];
    
    enterpriseIdInProcess = enterpriseId;
}

-(void) _reAttach
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:CGPointMake(160, screenHeight / 2 - 10)];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* enterpriseAccount = [dao queryAccountById:enterpriseIdInProcess];
        
        NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_account=%@", userId, enterpriseAccount];
        NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:APPEND_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
            
            [dao updateDisplayById:enterpriseIdInProcess value:@"yes"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AddShopView *myView = (AddShopView*)self.view;
                [myView.list reload];
                
                if([StringUtils isEmpty:userData.enterpriseId]){
                    [UserData writeCurrentEnterprise:enterpriseIdInProcess];
                }
                
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            });
        }];
    });
}

-(void) undoAttach:(NSString*)enterpriseId name:(NSString*)enterpriseName;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"解除关联后，您将看不到该店铺的任何信息，是否解除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alert.tag = CONFIRM_UNDO_ATTACH;
    [alert show];
    
    enterpriseIdInProcess = enterpriseId;
}

-(void) _undoAttach
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:CGPointMake(160, screenHeight / 2 - 10)];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    
    NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_id=%@", userId, enterpriseIdInProcess];
    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [httpHelper postSecure:REMOVE_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
        
        [dao updateDisplayById:enterpriseIdInProcess value:@"no"];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AddShopView *myView = (AddShopView*)self.view;
            [myView.list reload];
            
            // 解除当前商户的关联
            if([userData.enterpriseId isEqualToString:enterpriseIdInProcess]){
                [UserData removeCurrentEnterprise];
            }
            
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        });
    }];
}

#pragma mark - timer

-(void) disableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = NO;
}

-(void) startTick
{
    resendCountdown = 90;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        
        AddShopView *myView = (AddShopView*)self.view;
        UIButton *button = myView.requireCodeButton;
        
        NSString *title = [NSString stringWithFormat:@"%d秒重发", resendCountdown];
        button.titleLabel.text = title;
        return;
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

-(void) enableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.titleLabel.text = @"获取验证码";
    button.enabled = YES;
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == CONFIRM_RE_ATTACH){
    
        switch (buttonIndex) {
            case 0:{
                break;
            }
            case 1:{
                [self _reAttach];
                break;
            }
            default:{
                break;
            }
        }
    }
    
    if(alertView.tag == CONFIRM_UNDO_ATTACH){
        switch (buttonIndex) {
            case 0:{
                break;
            }
            case 1:{
                [self _undoAttach];
                break;
            }
            default:{
                break;
            }
        }
    }
}

@end
