#import "RegisterStepOneViewController.h"
#import "RegisterStepOneView.h"
#import "LoginViewController.h"

@implementation RegisterStepOneViewController

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
    RegisterStepOneView *view = [[RegisterStepOneView alloc] initWithController:self];
    self.view = view;
}

-(void) closeButtonPressed
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
        
        RegisterStepOneView *myView = (RegisterStepOneView*)self.view;
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
        
        // 拼接成以下格式：username_password
        NSString *plainText = [NSString stringWithFormat:@"%@_%@", userName, password];
        NSString *encoded = [StringUtils encodeWithBase64:plainText];
        NSData *postData = [[@"info=" stringByAppendingString:encoded] dataUsingEncoding:NSUTF8StringEncoding];

        [httpHelper postSecure:REGISTER_URL Data:postData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
            // network error
            if(error){
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            // response parse error
            NSError *parseError = nil;
            NSDictionary *parseResult = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
            if(parseError){
                NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"parse response error, the http response body is: %@", body);
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册失败，请联系客服" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            // server logic error
            NSString *code = [parseResult objectForKey:@"code"];
            if(![code isEqualToString:@"0"]){
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
