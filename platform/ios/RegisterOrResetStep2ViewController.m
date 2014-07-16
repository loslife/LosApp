#import "RegisterOrResetStep2ViewController.h"
#import "RegisterOrResetStep2View.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"
#import "StringUtils.h"

@implementation RegisterOrResetStep2ViewController

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
    RegisterOrResetStep2View *view = [[RegisterOrResetStep2View alloc] initWithController:self];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if([self.type isEqualToString:@"register"]){
        navigationItem.title = @"注册";
    }else{
        navigationItem.title = @"重设密码";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = backButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
}

-(void) submitButtonTapped
{
    RegisterOrResetStep2View *myView = (RegisterOrResetStep2View*)self.view;
    NSString *password = myView.password.text;
    NSString *repeat = myView.repeat.text;
    
    int flag = [self checkInputWithPassword:password repeat:repeat];
    if(flag != 0){
        
        if(flag == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        if(flag == 2){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        if(flag == 3){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码长度错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        return;
    }
    
    [self doSubmit:self.phone Password:password];
}

-(int) checkInputWithPassword:(NSString*)password repeat:(NSString*)repeat
{
    if([StringUtils isEmpty:password] || [StringUtils isEmpty:repeat]){
        return 1;
    }
    
    if(![password isEqualToString:repeat]){
        return 2;
    }
    
    if(password.length < 6 || password.length > 12){
        return 3;
    }
    
    return 0;
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
            [self back];
        });
    }];
}

-(void) back
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
