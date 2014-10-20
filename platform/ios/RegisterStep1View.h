#import <UIKit/UIKit.h>
#import "RegisterStep1ViewController.h"
#import "LosBaseView.h"

@interface RegisterStep1View : LosBaseView

@property UITextField *username;
@property UITextField *code;
@property UIButton *requireCodeButton;
@property UIButton *submit;

@property UILabel *sentMessage;
@property UILabel *expiredMessage;

-(id) initWithController:(RegisterStep1ViewController*)controller;

@end
