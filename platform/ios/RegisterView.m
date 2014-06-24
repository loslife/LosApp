#import "RegisterView.h"

@implementation RegisterView

{
    id currentResponder;
}

-(id) initWithController:(RegisterViewController*)controller
{
    self = [super init];
    if (self) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        closeButton.frame = CGRectMake(10, 10, 50, 50);
        [closeButton setTitle:@"返回" forState:UIControlStateNormal];
        [closeButton addTarget:controller action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
        label.text = @"注册用户";
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
        
        UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        registerBtn.frame = CGRectMake(60, 400, 200, 50);
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn addTarget:controller action:@selector(registerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeButton];
        [self addSubview:label];
        [self addSubview:self.username];
        [self addSubview:self.password];
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
