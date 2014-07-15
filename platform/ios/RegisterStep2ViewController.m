#import "RegisterStep2ViewController.h"
#import "RegisterStep2View.h"

@implementation RegisterStep2ViewController

-(void) loadView
{
    RegisterStep2View *view = [[RegisterStep2View alloc] initWithController:self Type:self.type];
    self.view = view;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    if([self.type isEqualToString:@"register"]){
        navigationItem.title = @"注册";
    }else{
        navigationItem.title = @"重设密码";
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = backButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
}

-(void) back
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
/**
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
**/
@end
