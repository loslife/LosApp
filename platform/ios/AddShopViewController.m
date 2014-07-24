#import "AddShopViewController.h"
#import "AddShopView.h"
#import "StringUtils.h"
#import "EnterpriseDao.h"
#import "UserData.h"

@implementation AddShopViewController

{
    NSTimer *timer;
    int resendCountdown;
    
    LosHttpHelper *httpHelper;
    SyncService *syncService;
    EnterpriseDao *dao;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        self.navigationItem.title = @"关联店铺";
        
        httpHelper = [[LosHttpHelper alloc] init];
        syncService = [[SyncService alloc] init];
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

-(void) appendEnterprise
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    UITextField *code = myView.code;
    
    BOOL inputCheck;
    
    inputCheck = [StringUtils isPhone:phone.text];
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
        NSString *userId = userData.userId;
        
        [syncService addEnterprise:userId EnterpriseAccount:phone.text Block:^(NSString* enterpriseId){
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if([StringUtils isEmpty:enterpriseId]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                
                [myView.list reload];
                
                UserData *userData = [UserData load];
                if([StringUtils isEmpty:userData.enterpriseId]){
                    [UserData writeCurrentEnterprise:enterpriseId];
                }
            });
        }];
    }];
}

#pragma mark - delegate

-(void) reAttach:(NSString*)enterpriseId
{
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* enterpriseAcccount = [dao queryAccountById:enterpriseId];
        
        [syncService reAttachWithAccount:userId enterpriseAccount:enterpriseAcccount block:^(BOOL flag){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AddShopView *myView = (AddShopView*)self.view;
                [myView.list reload];
                
                UserData *userData = [UserData load];
                if([StringUtils isEmpty:userData.enterpriseId]){
                    [UserData writeCurrentEnterprise:enterpriseId];
                }
            });
        }];
    });
}

-(void) undoAttach:(NSString*)enterpriseId
{
    UserData *userData = [UserData load];
    NSString* userId = userData.userId;
    
    [syncService undoAttachWithAccount:userId enterpriseId:enterpriseId block:^(BOOL flag){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AddShopView *myView = (AddShopView*)self.view;
            [myView.list reload];
            
            // 解除当前商户的关联
            UserData *userData = [UserData load];
            if([userData.enterpriseId isEqualToString:enterpriseId]){
                [UserData removeCurrentEnterprise];
            }
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
    resendCountdown = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        
        AddShopView *myView = (AddShopView*)self.view;
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
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.titleLabel.text = @"获取验证码";
    button.enabled = YES;
}

@end
