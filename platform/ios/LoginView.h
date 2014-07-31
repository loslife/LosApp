#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LosBaseView.h"

@interface LoginView : LosBaseView

@property UITextField *username;
@property UITextField *password;
@property UIButton *login;

-(id) initWithController:(LoginViewController*)controller;

@end
