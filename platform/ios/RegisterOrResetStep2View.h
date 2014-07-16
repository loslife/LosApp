#import "LosBaseView.h"
#import "RegisterOrResetStep2ViewController.h"

@interface RegisterOrResetStep2View : LosBaseView

@property UITextField *password;
@property UITextField *repeat;
@property UIButton *submit;

-(id) initWithController:(RegisterOrResetStep2ViewController*)controller;

@end
