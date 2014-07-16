#import "ResetStep1View.h"
#import "LosStyles.h"

@implementation ResetStep1View

-(id) initWithController:(ResetStep1ViewController*)controller
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = GRAY1;
        
        self.username = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        self.username.placeholder = @"输入您的手机号";
        self.username.borderStyle = UITextBorderStyleRoundedRect;
        self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.username.delegate = self;
        [self.username setKeyboardType:UIKeyboardTypeNumberPad];
        
        self.code = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
        self.code.placeholder = @"输入验证码";
        self.code.borderStyle = UITextBorderStyleRoundedRect;
        self.code.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.code setKeyboardType:UIKeyboardTypeNumberPad];
        self.code.delegate = self;
        
        self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.requireCodeButton.frame = CGRectMake(200, 180, 100, 40);
        [self.requireCodeButton setTitle:@"    获取验证码" forState:UIControlStateNormal];
        self.requireCodeButton.tintColor = BLUE2;
        self.requireCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.requireCodeButton addTarget:controller action:@selector(requireVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        
        self.submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.submit.frame = CGRectMake(20, 230, 280, 40);
        [self.submit setTitle:@"下一步，设置密码" forState:UIControlStateNormal];
        self.submit.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.submit.backgroundColor = BLUE1;
        self.submit.tintColor = [UIColor whiteColor];
        self.submit.layer.cornerRadius = 5;
        [self.submit addTarget:controller action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.username];
        [self addSubview:self.code];
        [self addSubview:self.requireCodeButton];
        [self addSubview:self.submit];
    }
    return self;
}
@end
