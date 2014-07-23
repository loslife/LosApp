#import "LoginOrRegisterView.h"
#import "LosStyles.h"

@implementation LoginOrRegisterView

-(id) initWithDelegate:(id<LoginOrRegisterViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login"]];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        loginButton.frame = CGRectMake(20, screenHeight - 88, 130, 40);
        [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
        loginButton.backgroundColor = BLUE1;
        loginButton.tintColor = [UIColor whiteColor];
        loginButton.layer.cornerRadius = 5;
        loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [loginButton addTarget:delegate action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        registerButton.frame = CGRectMake(170, screenHeight - 88, 130, 40);
        [registerButton setTitle:@"注 册" forState:UIControlStateNormal];
        registerButton.backgroundColor = RED1;
        registerButton.tintColor = [UIColor whiteColor];
        registerButton.layer.cornerRadius = 5;
        registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [registerButton addTarget:delegate action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:loginButton];
        [self addSubview:registerButton];
    }
    return self;
}

@end
