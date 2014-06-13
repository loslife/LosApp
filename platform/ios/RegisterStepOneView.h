#import <UIKit/UIKit.h>
#import "RegisterStepOneViewController.h"

@interface RegisterStepOneView : UIView<UITextFieldDelegate>

@property UITextField *username;
@property UITextField *password;

-(id) initWithController:(RegisterStepOneViewController*)controller;

@end
