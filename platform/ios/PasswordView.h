#import "LosBaseView.h"
#import "PasswordViewController.h"

@interface PasswordView : LosBaseView

@property UITextField *oldPassword;
@property UITextField *password;
@property UITextField *passwordRepeat;

-(id) initWithController:(PasswordViewController*)controller;

@end
