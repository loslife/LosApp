#import "LoginView.h"

@implementation LoginView

{
    id currentResponder;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 50)];
        label.text = @"乐斯";
        label.textAlignment = NSTextAlignmentCenter;
        
        UITextField *username = [[UITextField alloc] initWithFrame:CGRectMake(60, 150, 200, 50)];
        username.placeholder = @"用户名";
        username.borderStyle = UITextBorderStyleRoundedRect;
        username.clearButtonMode = UITextFieldViewModeWhileEditing;
        [username setKeyboardType:UIKeyboardTypeNumberPad];
        username.delegate = self;
        
        UITextField *password = [[UITextField alloc] initWithFrame:CGRectMake(60, 210, 200, 50)];
        password.placeholder = @"密码";
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [password setSecureTextEntry:YES];
        password.delegate = self;
        
        UIButton *login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        login.frame = CGRectMake(60, 400, 200, 50);
        [login setTitle:@"登陆" forState:UIControlStateNormal];
        
        [self addSubview:label];
        [self addSubview:username];
        [self addSubview:password];
        [self addSubview:login];
        
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
