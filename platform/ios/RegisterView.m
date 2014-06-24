#import "RegisterView.h"

@implementation RegisterView

{
    id currentResponder;
}

-(id) initWithController:(RegisterViewController*)controller Type:(NSString*)type
{
    self = [super init];
    if (self) {
        
        UIView *phoneArea = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        
        UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        phoneLabel.text = @"手机号码";
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.username.placeholder = @"输入手机号";
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.username.delegate = self;
        [self.username setKeyboardType:UIKeyboardTypeNumberPad];
        
        [phoneArea addSubview:phoneLabel];
        [phoneArea addSubview:self.username];
        
        UIView *codeWrapper = [[UIView alloc] initWithFrame:CGRectMake(20, 140, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"验证码";
        label.textAlignment = NSTextAlignmentLeft;
        
        self.code = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 110, 40)];
        self.code.placeholder = @"输入验证码";
        self.code.borderStyle = UITextBorderStyleRoundedRect;
        self.code.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.code setKeyboardType:UIKeyboardTypeNumberPad];
        self.code.delegate = self;
        
        self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.requireCodeButton.frame = CGRectMake(200, 0, 80, 40);
        [self.requireCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.requireCodeButton setTitle:@"60秒可重发" forState:UIControlStateDisabled];
        self.requireCodeButton.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
        self.requireCodeButton.tintColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
        self.requireCodeButton.layer.cornerRadius = 5;
        [self.requireCodeButton addTarget:controller action:@selector(requireVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        
        [codeWrapper addSubview:label];
        [codeWrapper addSubview:self.code];
        [codeWrapper addSubview:self.requireCodeButton];
        
        UIView *passwordArea = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        passwordLabel.text = @"输入密码";
        passwordLabel.textAlignment = NSTextAlignmentLeft;
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.password.placeholder = @"字母和数字的组合";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.password.delegate = self;
        [self.password setSecureTextEntry:YES];
        
        [passwordArea addSubview:passwordLabel];
        [passwordArea addSubview:self.password];
        
        UIView *repeatArea = [[UIView alloc] initWithFrame:CGRectMake(20, 260, 280, 40)];
        
        UILabel *repeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        repeatLabel.text = @"确认密码";
        repeatLabel.textAlignment = NSTextAlignmentLeft;
        
        self.passwordRepeat = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.passwordRepeat.placeholder = @"再次输入新密码";
        self.passwordRepeat.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordRepeat.delegate = self;
        [self.passwordRepeat setSecureTextEntry:YES];
        
        [repeatArea addSubview:repeatLabel];
        [repeatArea addSubview:self.passwordRepeat];
        
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submit.frame = CGRectMake(20, 320, 280, 40);
        if([type isEqualToString:@"register"]){
            [submit setTitle:@"注册" forState:UIControlStateNormal];
        }else{
            [submit setTitle:@"重设密码" forState:UIControlStateNormal];
        }
        submit.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        submit.tintColor = [UIColor whiteColor];
        submit.layer.cornerRadius = 5;
        [submit addTarget:controller action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:phoneArea];
        [self addSubview:codeWrapper];
        [self addSubview:passwordArea];
        [self addSubview:repeatArea];
        [self addSubview:submit];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
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
