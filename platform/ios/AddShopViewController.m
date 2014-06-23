#import "AddShopViewController.h"
#import "AddShopView.h"

@implementation AddShopViewController

{
    NSTimer *timer;
    int resendCountdown;
    LosHttpHelper *httpHelper;
    DBService *dbService;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.navigationItem.title = @"关联店铺";
        
        httpHelper = [[LosHttpHelper alloc] init];
        dbService = [[DBService alloc] init];
    }
    return self;
}

-(void) loadView
{
    AddShopView *view = [[AddShopView alloc] initWithController:self];
    self.view = view;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void) viewDidAppear:(BOOL)animated
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    if(button.enabled){
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) requireVerificationCode
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    
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

-(void) appendEnterprise
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    UITextField *code = myView.code;
    
    BOOL inputCheck;
    
    inputCheck = [self checkPhone:phone.text];
    if(!inputCheck){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([@"" isEqualToString:code.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL, phone.text, @"attach", code.text];
    
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
        
        UserData *userData = [UserData load];
        NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_account=%@", userData.userId, phone.text];
        NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:APPEND_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
        
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSDictionary *result = [dict objectForKey:@"result"];
            NSString *enterpriseId = [result objectForKey:@"enterprise_id"];
            NSString *enterpriseName = [result objectForKey:@"enterprise_name"];
            
            [dbService addEnterprise:enterpriseId Name:enterpriseName];
            
            NSString *url = [NSString stringWithFormat:SYNC_MEMBERS_URL, enterpriseId, @"1", @"0"];
            
            [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
                
                NSDictionary *response = [dict objectForKey:@"result"];
                NSNumber *lastSync = [response objectForKey:@"last_sync"];
                NSDictionary *records = [response objectForKey:@"records"];
                
                [dbService refreshMembersWithRecords:records LastSync:lastSync EnterpriseId:enterpriseId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
            }];
        }];
    }];
}

#pragma mark - private method

-(BOOL) checkPhone:(NSString*)phone
{
    NSString *phoneRegex = @"^((13)|(15)|(18))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark - timer

-(void) disableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
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
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
}

@end
