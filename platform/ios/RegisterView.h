#import <UIKit/UIKit.h>
#import "RegisterViewController.h"

@interface RegisterView : UIView<UITextFieldDelegate>

@property UITextField *username;
@property UITextField *password;

-(id) initWithController:(RegisterViewController*)controller;

@end
