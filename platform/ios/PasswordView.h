#import <UIKit/UIKit.h>
#import "PasswordViewController.h"

@interface PasswordView : UIView<UITextFieldDelegate>

@property UITextField *oldPassword;
@property UITextField *password;
@property UITextField *passwordRepeat;

-(id) initWithController:(PasswordViewController*)controller;

@end
