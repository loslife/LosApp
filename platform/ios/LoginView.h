#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface LoginView : UIView<UITextFieldDelegate>

@property UITextField *username;
@property UITextField *password;
@property UIButton *login;

-(id) initWithController:(LoginViewController*)controller;

@end
