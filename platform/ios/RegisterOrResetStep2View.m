#import "RegisterOrResetStep2View.h"
#import "LosStyles.h"

@implementation RegisterOrResetStep2View

-(id) initWithController:(RegisterOrResetStep2ViewController*)controller;
{
    self = [super init];
    if(self){
        
        self.backgroundColor = GRAY1;
        
        self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        self.password.placeholder = @"输入密码";
        self.password.borderStyle = UITextBorderStyleRoundedRect;
        self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.password setKeyboardType:UIKeyboardTypeNumberPad];
        self.password.secureTextEntry = YES;
        self.password.delegate = self;
        
        self.repeat = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
        self.repeat.placeholder = @"再次输入密码";
        self.repeat.borderStyle = UITextBorderStyleRoundedRect;
        self.repeat.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.repeat setKeyboardType:UIKeyboardTypeNumberPad];
        self.repeat.secureTextEntry = YES;
        self.repeat.delegate = self;
        
        self.submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.submit.frame = CGRectMake(20, 180, 280, 40);
        [self.submit setTitle:@"完成" forState:UIControlStateNormal];
        self.submit.backgroundColor = BLUE1;
        self.submit.tintColor = [UIColor whiteColor];
        self.submit.layer.cornerRadius = 5;
        [self.submit addTarget:controller action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.password];
        [self addSubview:self.repeat];
        [self addSubview:self.submit];
    }
    return self;
}

@end
