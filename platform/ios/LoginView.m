#import "LoginView.h"
#import "LosTextField.h"

@implementation LoginView

{
    id currentResponder;
}

-(id) initWithController:(LoginViewController*)controller
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
        
        self.username = [[LosTextField alloc] initWithFrame:CGRectMake(20, 150, 280, 40) Icon:@"login_username"];
        self.username.placeholder = @"用户名";
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.username setKeyboardType:UIKeyboardTypeNumberPad];
        self.username.delegate = self;

        self.password = [[LosTextField alloc] initWithFrame:CGRectMake(20, 200, 280, 40) Icon:@"login_password"];
        self.password.placeholder = @"密码";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setSecureTextEntry:YES];
        self.password.delegate = self;
        
        self.login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.login.frame = CGRectMake(60, 400, 200, 50);
        [self.login setTitle:@"登陆" forState:UIControlStateNormal];
        [self.login addTarget:controller action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        registerBtn.frame = CGRectMake(60, 460, 200, 50);
        [registerBtn setTitle:@"免费注册" forState:UIControlStateNormal];
        [registerBtn addTarget:controller action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.username];
        [self addSubview:self.password];
        [self addSubview:self.login];
        [self addSubview:registerBtn];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
        [singleTap setNumberOfTapsRequired:1];// 触摸一次
        [singleTap setNumberOfTouchesRequired:1];// 单指触摸
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

#pragma mark - TextFieldDelegate

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentResponder = textField;
}

#pragma mark - gesture recognize

-(void) resignOnTap
{
    [currentResponder resignFirstResponder];
}

@end
