#import <UIKit/UIKit.h>
#import "RegisterViewController.h"

@interface RegisterView : UIView<UITextFieldDelegate>

@property UITextField *username;
@property UITextField *code;
@property UITextField *password;
@property UITextField *passwordRepeat;
@property UIButton *requireCodeButton;

-(id) initWithController:(RegisterViewController*)controller;

@end
