#import "LosBaseView.h"
#import "PasswordViewController.h"

@interface PasswordView : LosBaseView

@property UITextField *oldPassword;
@property UITextField *password;
@property UITextField *passwordRepeat;
@property UIButton *submit;

-(id) initWithController:(PasswordViewController*)controller;

@end
