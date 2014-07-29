#import "PasswordViewController.h"
#import "PasswordView.h"
#import "StringUtils.h"
#import "LosHttpHelper.h"
#import "UserData.h"
#import "LosAppUrls.h"

@implementation PasswordViewController

{
    LosHttpHelper *httpHelper;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        httpHelper = [[LosHttpHelper alloc] init];
        
        self.navigationItem.title = @"修改密码";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void) loadView
{
    PasswordView *view = [[PasswordView alloc] initWithController:self];
    self.view = view;
}

-(void) modifyPassword
{
    PasswordView *myView = (PasswordView*)self.view;
    myView.submit.enabled = NO;
    
    int flag = [self checkInput];
    
    if(flag != 0){
        if(flag == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
        myView.submit.enabled = YES;
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL network = [LosHttpHelper isNetworkAvailable];
        
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
                myView.submit.enabled = YES;
            });
            return;
        }
        
        PasswordView *myView = (PasswordView*)self.view;
        NSString *oldPassword = myView.oldPassword.text;
        NSString *newPassword = myView.password.text;
        
        UserData *userData = [UserData load];
        NSString *userId = userData.userId;
       
        NSString *data = [NSString stringWithFormat:@"account=%@&old_password=%@&new_password=%@", userId, oldPassword, newPassword];
        NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:MODIFY_PASSWORD_URL Data:postData completionHandler:^(NSDictionary *result){
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
            
                if(result == nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    myView.submit.enabled = YES;
    
                    return;
                }
                
                NSNumber *code = [result objectForKey:@"code"];
                if([code intValue] != 0){
                    
                    NSDictionary *dict = [result objectForKey:@"result"];
                    NSString *errorCode = [dict objectForKey:@"errorCode"];
                    
                    if([errorCode isEqualToString:@"501"]){
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"旧密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                        myView.submit.enabled = YES;
                        
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                        myView.submit.enabled = YES;
                    }
                    
                    return;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                
                myView.oldPassword.text = @"";
                myView.password.text = @"";
                myView.passwordRepeat.text = @"";
                myView.submit.enabled = YES;
            });
        }];
    });
}

-(int) checkInput
{
    PasswordView *myView = (PasswordView*)self.view;
    
    NSString *oldPassword = myView.oldPassword.text;
    NSString *newPassword = myView.password.text;
    NSString *repeatPassword = myView.passwordRepeat.text;
    
    if([StringUtils isEmpty:oldPassword] || [StringUtils isEmpty:newPassword] || [StringUtils isEmpty:repeatPassword]){
        return 1;
    }
    
    if(![newPassword isEqualToString:repeatPassword]){
        return 2;
    }
    
    if(newPassword.length < 6 || newPassword.length > 16){
        return 3;
    }
    
    return 0;
}

@end
