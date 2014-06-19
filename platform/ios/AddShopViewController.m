#import "AddShopViewController.h"

@implementation AddShopViewController

{
    id currentResponder;
}

-(void) loadView
{
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
    label.text = @"关联店铺";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
    
    UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
    phone.placeholder = @"输入关联店铺的乐斯登陆账号";
    phone.borderStyle = UITextBorderStyleRoundedRect;
    phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phone setKeyboardType:UIKeyboardTypeNumberPad];
    phone.delegate = self;
    
    UIView *codeWrapper = [[UIView alloc] initWithFrame:CGRectMake(20, 220, 280, 40)];
    
    UITextField *code = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
    code.placeholder = @"输入验证码";
    code.borderStyle = UITextBorderStyleRoundedRect;
    code.clearButtonMode = UITextFieldViewModeWhileEditing;
    [code setKeyboardType:UIKeyboardTypeNumberPad];
    code.delegate = self;
    
    UIButton *requireCode = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    requireCode.frame = CGRectMake(190, 0, 90, 40);
    [requireCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    requireCode.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
    requireCode.tintColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
    requireCode.layer.cornerRadius = 5;
    
    [codeWrapper addSubview:code];
    [codeWrapper addSubview:requireCode];
    
    UIButton *attach = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    attach.frame = CGRectMake(20, 280, 280, 40);
    [attach setTitle:@"立即关联" forState:UIControlStateNormal];
    attach.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
    attach.tintColor = [UIColor whiteColor];
    attach.layer.cornerRadius = 5;
    
    UITextView *notice = [[UITextView alloc] init];
    notice.frame = CGRectMake(20, 320, 280, 120);
    notice.text = @"小贴士：关联店铺完成后，在手机中可以查看店铺中的实时经营数据以及所有的会员资料。";
    notice.delegate = self;
    
    [view addSubview:label];
    [view addSubview:phone];
    [view addSubview:codeWrapper];
    [view addSubview:attach];
    [view addSubview:notice];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:singleTap];
    
    self.view = view;
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
