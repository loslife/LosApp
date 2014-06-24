#import "PasswordView.h"

@implementation PasswordView

{
    id currentResponder;
}

-(id) initWithController:(PasswordViewController*)controller
{
    self = [super init];
    if (self) {
        
        UIView *oldPasswordArea = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        
        UILabel *oldPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        oldPasswordLabel.text = @"当前密码";
        oldPasswordLabel.textAlignment = NSTextAlignmentLeft;
        
        self.oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.oldPassword.placeholder = @"输入原始密码";
        self.oldPassword.borderStyle = UITextBorderStyleRoundedRect;
        self.oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.oldPassword setSecureTextEntry:YES];
        self.oldPassword.delegate = self;
        
        [oldPasswordArea addSubview:oldPasswordLabel];
        [oldPasswordArea addSubview:self.oldPassword];
        
        UIView *newPasswordArea = [[UIView alloc] initWithFrame:CGRectMake(20, 140, 280, 40)];
        
        UILabel *newPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        newPasswordLabel.text = @"新密码";
        newPasswordLabel.textAlignment = NSTextAlignmentLeft;
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.password.placeholder = @"字母和数字的组合";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setSecureTextEntry:YES];
        self.password.delegate = self;
        
        [newPasswordArea addSubview:newPasswordLabel];
        [newPasswordArea addSubview:self.password];
        
        UIView *repeatPasswordArea = [[UIView alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        
        UILabel *repeatPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        repeatPasswordLabel.text = @"确认密码";
        repeatPasswordLabel.textAlignment = NSTextAlignmentLeft;
        
        self.passwordRepeat = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        self.passwordRepeat.placeholder = @"再次输入新密码";
        self.passwordRepeat.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.passwordRepeat setSecureTextEntry:YES];
        self.passwordRepeat.delegate = self;
        
        [repeatPasswordArea addSubview:repeatPasswordLabel];
        [repeatPasswordArea addSubview:self.passwordRepeat];
        
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submit.frame = CGRectMake(20, 260, 280, 40);
        [submit setTitle:@"确定" forState:UIControlStateNormal];
        submit.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        submit.tintColor = [UIColor whiteColor];
        submit.layer.cornerRadius = 5;
        [submit addTarget:controller action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:oldPasswordArea];
        [self addSubview:newPasswordArea];
        [self addSubview:repeatPasswordArea];
        [self addSubview:submit];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
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

-(void) closeKeyboard
{
    [currentResponder resignFirstResponder];
}

@end
