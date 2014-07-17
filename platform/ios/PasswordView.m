#import "PasswordView.h"
#import "LosStyles.h"

@implementation PasswordView

-(id) initWithController:(PasswordViewController*)controller
{
    self = [super init];
    if (self) {
        
        self.oldPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        self.oldPassword.placeholder = @"输入当前密码";
        self.oldPassword.borderStyle = UITextBorderStyleRoundedRect;
        self.oldPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.oldPassword setSecureTextEntry:YES];
        self.oldPassword.delegate = self;
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
        self.password.placeholder = @"输入新密码";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setSecureTextEntry:YES];
        self.password.delegate = self;
        
        self.passwordRepeat = [[UITextField alloc] initWithFrame:CGRectMake(20, 180, 280, 40)];
        self.passwordRepeat.placeholder = @"再次输入新密码";
        self.passwordRepeat.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.passwordRepeat setSecureTextEntry:YES];
        self.passwordRepeat.delegate = self;
        
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        submit.frame = CGRectMake(20, 240, 280, 40);
        [submit setTitle:@"完成" forState:UIControlStateNormal];
        submit.backgroundColor = BLUE1;
        submit.tintColor = [UIColor whiteColor];
        submit.layer.cornerRadius = 5;
        [submit addTarget:controller action:@selector(modifyPassword) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = GRAY1;
        [self addSubview:self.oldPassword];
        [self addSubview:self.password];
        [self addSubview:self.passwordRepeat];
        [self addSubview:submit];
    }
    return self;
}

@end
