#import "LosBaseView.h"
#import "ResetStep1ViewController.h"

@interface ResetStep1View : LosBaseView

@property UITextField *username;
@property UITextField *code;
@property UIButton *requireCodeButton;
@property UIButton *submit;

-(id) initWithController:(ResetStep1ViewController*)controller;

@end
