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
        self.login.frame = CGRectMake(20, 250, 280, 40);
        [self.login setTitle:@"登  陆" forState:UIControlStateNormal];
        self.login.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        self.login.tintColor = [UIColor whiteColor];
        self.login.layer.cornerRadius = 5;
        self.login.layer.shadowColor = [UIColor colorWithRed:132/255.0f green:214/255.0f blue:219/255.0f alpha:1.0f].CGColor;
        self.login.layer.shadowOpacity = 0.5;
        self.login.layer.shadowOffset = CGSizeMake(3, 3);
        self.login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.login addTarget:controller action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 300, 280, 40)];
        
        UIImage *registerImage = [UIImage imageNamed:@"register_icon"];
        UIImageView *registerIcon = [[UIImageView alloc] initWithImage:registerImage];
        registerIcon.frame = CGRectMake(0, 9, 13, 13);
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        registerButton.frame = CGRectMake(18, 0, 102, 30);
        [registerButton setTitle:@"免费注册" forState:UIControlStateNormal];
        [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [registerButton addTarget:controller action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *resetImage = [UIImage imageNamed:@"reset_icon"];
        UIImageView *resetIcon = [[UIImageView alloc] initWithImage:resetImage];
        resetIcon.frame = CGRectMake(185, 9, 13, 13);
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        forgetButton.frame = CGRectMake(173, 0, 107, 30);
        [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgetButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetButton addTarget:controller action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [bottomView addSubview:registerIcon];
        [bottomView addSubview:registerButton];
        [bottomView addSubview:resetIcon];
        [bottomView addSubview:forgetButton];
        
        [self addSubview:self.username];
        [self addSubview:self.password];
        [self addSubview:self.login];
        [self addSubview:bottomView];
        
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
