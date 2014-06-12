#import "LoginView.h"

@implementation LoginView

{
    id currentResponder;
}

-(id) initWithController:(LoginViewController*)controller
{
    self = [super init];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
        label.text = @"乐斯";
        label.textAlignment = NSTextAlignmentCenter;
        
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(60, 150, 200, 50)];
        self.username.placeholder = @"用户名";
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.username setKeyboardType:UIKeyboardTypeNumberPad];
        self.username.delegate = self;
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(60, 210, 200, 50)];
        self.password.placeholder = @"密码";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setSecureTextEntry:YES];
        self.password.delegate = self;
        
        self.login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.login.frame = CGRectMake(60, 400, 200, 50);
        [self.login setTitle:@"登陆" forState:UIControlStateNormal];
        [self.login addTarget:controller action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:label];
        [self addSubview:self.username];
        [self addSubview:self.password];
        [self addSubview:self.login];
        
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
