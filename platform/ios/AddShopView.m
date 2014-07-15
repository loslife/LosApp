#import "AddShopView.h"

@implementation AddShopView

{
    id<EnterpriseListViewDelegate> myDelegate;
    
    id currentResponder;
    
    UIView *label;
    UIView *form;

    BOOL isUnfold;
    CGFloat listContentHeight;
    CGFloat formHeight;
    CGFloat labelHeight;
}

-(id) initWithController:(AddShopViewController*)controller
{
    self = [super init];
    if(self){
        
        myDelegate = controller;
        
        isUnfold = NO;
        labelHeight = 50;
        formHeight = 240;
        [self calculateListHeight];
        
        label = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, labelHeight)];
        
        UIButton *unfold = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        unfold.frame = CGRectMake(0, 0, 320, 50);
        [unfold setTitle:@"添加关联" forState:UIControlStateNormal];
        [unfold addTarget:self action:@selector(unfold) forControlEvents:UIControlEventTouchUpInside];
        
        [label addSubview:unfold];
        
        form = [[UIView alloc] initWithFrame:CGRectMake(0, -240, 320, formHeight)];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.frame = CGRectMake(0, 0, 320, 50);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(fold) forControlEvents:UIControlEventTouchUpInside];
        
        self.phone = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, 320, 40)];
        self.phone.placeholder = @"输入关联店铺的乐斯登陆账号";
        self.phone.borderStyle = UITextBorderStyleRoundedRect;
        self.phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phone setKeyboardType:UIKeyboardTypeNumberPad];
        self.phone.delegate = self;
        
        UIView *codeWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 90, 320, 40)];
        
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
        attach.frame = CGRectMake(0, 130, 320, 40);
        [attach setTitle:@"立即关联" forState:UIControlStateNormal];
        attach.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        attach.tintColor = [UIColor whiteColor];
        attach.layer.cornerRadius = 5;
        [attach addTarget:controller action:@selector(appendEnterprise) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 70)];
        notice.text = @"小贴士：关联店铺完成后，在手机中可以查看店铺中的实时经营数据以及所有的会员资料。";
        notice.numberOfLines = 3;
        
        [form addSubview:cancel];
        [form addSubview:self.phone];
        [form addSubview:codeWrapper];
        [form addSubview:attach];
        [form addSubview:notice];
        
        self.list = [[EnterpriseListView alloc] initWithFrame:CGRectMake(0, 110, 320, listContentHeight) Delegate:controller];
        
        [self addSubview:label];
        [self addSubview:form];
        [self addSubview:self.list];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void) calculateListHeight
{
    CGFloat actualHeight = 548 - 20 - 44 - 49;
    
    CGFloat minHeight;
    if(isUnfold){
        minHeight = actualHeight - formHeight;
    }else{
        minHeight = actualHeight - labelHeight;
    }
    
    CGFloat contentHeight = 5 + 40 * [myDelegate count];
    if(contentHeight < minHeight){
        listContentHeight = minHeight;
    }else{
        listContentHeight = contentHeight;
    }
}

-(void) unfold
{
    isUnfold = YES;
    [self calculateListHeight];
    
    [UIView animateWithDuration:0.5 animations:^{
    
        form.frame = CGRectMake(0, 64, 320, formHeight);
        label.frame = CGRectMake(0, -labelHeight, 320, labelHeight);
        self.list.frame = CGRectMake(0, 64 + formHeight, 320, listContentHeight);
    }];
}

-(void) fold
{
    isUnfold = NO;
    [self calculateListHeight];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        form.frame = CGRectMake(0, formHeight, 320, formHeight);
        label.frame = CGRectMake(0, 64, 320, labelHeight);
        self.list.frame = CGRectMake(0, 64 + labelHeight, 320, listContentHeight);
    }];
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
