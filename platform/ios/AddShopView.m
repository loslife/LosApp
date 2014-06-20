#import "AddShopView.h"

@implementation AddShopView

{
    id currentResponder;
}

-(id) initWithController:(AddShopViewController*)controller
{
    self = [super init];
    if(self){
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        label.text = @"关联店铺";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
        
        self.phone = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
        self.phone.placeholder = @"输入关联店铺的乐斯登陆账号";
        self.phone.borderStyle = UITextBorderStyleRoundedRect;
        self.phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phone setKeyboardType:UIKeyboardTypeNumberPad];
        self.phone.delegate = self;
        
        UIView *codeWrapper = [[UIView alloc] initWithFrame:CGRectMake(20, 220, 280, 40)];
        
        self.code = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        self.code.placeholder = @"输入验证码";
        self.code.borderStyle = UITextBorderStyleRoundedRect;
        self.code.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.code setKeyboardType:UIKeyboardTypeNumberPad];
        self.code.delegate = self;
        
        self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.requireCodeButton.frame = CGRectMake(190, 0, 90, 40);
        [self.requireCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.requireCodeButton setTitle:@"60秒可重发" forState:UIControlStateDisabled];
        self.requireCodeButton.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
        self.requireCodeButton.tintColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
        self.requireCodeButton.layer.cornerRadius = 5;
        [self.requireCodeButton addTarget:controller action:@selector(requireVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        
        [codeWrapper addSubview:self.code];
        [codeWrapper addSubview:self.requireCodeButton];
        
        UIButton *attach = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        attach.frame = CGRectMake(20, 280, 280, 40);
        [attach setTitle:@"立即关联" forState:UIControlStateNormal];
        attach.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        attach.tintColor = [UIColor whiteColor];
        attach.layer.cornerRadius = 5;
        [attach addTarget:controller action:@selector(appendEnterprise) forControlEvents:UIControlEventTouchUpInside];
        
        UITextView *notice = [[UITextView alloc] init];
        notice.frame = CGRectMake(20, 320, 280, 120);
        notice.text = @"小贴士：关联店铺完成后，在手机中可以查看店铺中的实时经营数据以及所有的会员资料。";
        notice.delegate = self;
        
        [self addSubview:label];
        [self addSubview:self.phone];
        [self addSubview:codeWrapper];
        [self addSubview:attach];
        [self addSubview:notice];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentResponder = textField;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

#pragma mark - gesture recognize

-(void) resignOnTap
{
    [currentResponder resignFirstResponder];
}

@end
