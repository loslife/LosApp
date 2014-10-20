#import "LoginView.h"
#import "LosTextField.h"
#import "LosStyles.h"

@implementation LoginView

-(id) initWithController:(LoginViewController*)controller
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = GRAY1;
        
        self.username = [[LosTextField alloc] initWithFrame:CGRectMake(20, 80, 280, 40) Icon:@"login_username"];
        self.username.placeholder = @"用户名";
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.username setKeyboardType:UIKeyboardTypeNumberPad];
        self.username.delegate = self;

        self.password = [[LosTextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40) Icon:@"login_password"];
        self.password.placeholder = @"密码";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setSecureTextEntry:YES];
        self.password.delegate = self;
        
        self.login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.login.frame = CGRectMake(20, 185, 280, 40);
        [self.login setTitle:@"完成" forState:UIControlStateNormal];
        self.login.backgroundColor = BLUE1;
        self.login.tintColor = [UIColor whiteColor];
        self.login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.login.layer.cornerRadius = 5;
        [self.login addTarget:controller action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *resetImage = [UIImage imageNamed:@"reset_icon"];
        UIImageView *resetIcon = [[UIImageView alloc] initWithImage:resetImage];
        resetIcon.frame = CGRectMake(225, 245, 10, 10);
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        forgetButton.frame = CGRectMake(200, 230, 100, 40);
        [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetButton.tintColor = BLUE1;
        forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [forgetButton addTarget:controller action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.username];
        [self addSubview:self.password];
        [self addSubview:self.login];
        [self addSubview:resetIcon];
        [self addSubview:forgetButton];
    }
    return self;
}

@end
