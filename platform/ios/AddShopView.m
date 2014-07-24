#import "AddShopView.h"

@implementation AddShopView

{
    UIView *label;
    UIView *form;

    BOOL isUnfold;
    CGFloat labelHeight;
    CGFloat formHeight;
    CGFloat listHeight;
}

-(id) initWithController:(AddShopViewController*)controller
{
    self = [super init];
    if(self){
        
        isUnfold = NO;
        labelHeight = 50;
        formHeight = 280;
        listHeight = 454;
        
        label = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, labelHeight)];
        
        UIButton *unfold = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        unfold.frame = CGRectMake(0, 0, 320, 50);
        [unfold setTitle:@"添加关联" forState:UIControlStateNormal];
        [unfold addTarget:self action:@selector(unfold) forControlEvents:UIControlEventTouchUpInside];
        unfold.titleLabel.font = [UIFont systemFontOfSize:13];
        unfold.tintColor = [UIColor colorWithRed:2/255.0f green:160/255.0f blue:221/255.0f alpha:1.0f];
        
        [label addSubview:unfold];
        
        form = [[UIView alloc] initWithFrame:CGRectMake(0, -formHeight, 320, formHeight)];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.frame = CGRectMake(0, 0, 320, 50);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(fold) forControlEvents:UIControlEventTouchUpInside];
        cancel.titleLabel.font = [UIFont systemFontOfSize:13];
        cancel.tintColor = [UIColor colorWithRed:2/255.0f green:160/255.0f blue:221/255.0f alpha:1.0f];
        
        self.phone = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 280, 40)];
        self.phone.borderStyle = UITextBorderStyleRoundedRect;
        self.phone.placeholder = @"输入需要关联店铺的乐斯账号";
        self.phone.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.phone setKeyboardType:UIKeyboardTypeNumberPad];
        self.phone.delegate = self;
        
        self.code = [[UITextField alloc] initWithFrame:CGRectMake(20, 95, 280, 40)];
        self.code.borderStyle = UITextBorderStyleRoundedRect;
        self.code.placeholder = @"输入验证码";
        self.code.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.code setKeyboardType:UIKeyboardTypeNumberPad];
        self.code.delegate = self;
        
        self.requireCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.requireCodeButton.frame = CGRectMake(210, 140, 90, 40);
        [self.requireCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.requireCodeButton setTitle:@"90秒可重发" forState:UIControlStateDisabled];
        [self.requireCodeButton addTarget:controller action:@selector(requireVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        self.requireCodeButton.titleLabel.textAlignment = NSTextAlignmentRight;
        self.requireCodeButton.titleLabel.textColor = [UIColor colorWithRed:2/255.0f green:160/255.0f blue:221/255.0f alpha:1.0f];
        
        UIButton *attach = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        attach.frame = CGRectMake(20, 180, 280, 40);
        [attach setTitle:@"立即关联" forState:UIControlStateNormal];
        attach.backgroundColor = [UIColor colorWithRed:2/255.0f green:160/255.0f blue:221/255.0f alpha:1.0f];
        attach.tintColor = [UIColor whiteColor];
        attach.layer.cornerRadius = 5;
        [attach addTarget:controller action:@selector(appendEnterprise) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *notice = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 280, 60)];
        notice.text = @"小贴士：关联店铺完成后，在手机中可以查看店铺中的实时经营数据以及所有的会员资料。";
        notice.numberOfLines = 3;
        notice.font = [UIFont systemFontOfSize:12];
        notice.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        [form addSubview:cancel];
        [form addSubview:self.phone];
        [form addSubview:self.code];
        [form addSubview:self.requireCodeButton];
        [form addSubview:attach];
        [form addSubview:notice];
        
        self.list = [[EnterpriseListView alloc] initWithFrame:CGRectMake(0, 110, 320, listHeight) Delegate:controller];
        
        [self addSubview:label];
        [self addSubview:form];
        [self addSubview:self.list];
    }
    return self;
}

-(void) calculateListHeight
{
    CGFloat actualHeight = 568 - 64;

    if(isUnfold){
        listHeight = actualHeight - formHeight;
    }else{
        listHeight = actualHeight - labelHeight;
    }
}

-(void) unfold
{
    isUnfold = YES;
    [self calculateListHeight];
    
    [UIView animateWithDuration:0.5 animations:^{
    
        form.frame = CGRectMake(0, 64, 320, formHeight);
        label.frame = CGRectMake(0, -labelHeight, 320, labelHeight);
        self.list.frame = CGRectMake(0, 64 + formHeight, 320, listHeight);
    } completion:^(BOOL finished){
        [self.list reload];
    }];
}

-(void) fold
{
    isUnfold = NO;
    [self calculateListHeight];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        form.frame = CGRectMake(0, -formHeight, 320, formHeight);
        label.frame = CGRectMake(0, 64, 320, labelHeight);
        self.list.frame = CGRectMake(0, 64 + labelHeight, 320, listHeight);
    } completion:^(BOOL finished){
        [self.list reload];
    }];
}

@end
