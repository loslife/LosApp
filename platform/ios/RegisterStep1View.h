#import <UIKit/UIKit.h>
#import "RegisterStep1ViewController.h"
#import "LosBaseView.h"

@interface RegisterStep1View : LosBaseView

@property UITextField *username;
@property UITextField *code;
@property UITextField *password;
@property UITextField *passwordRepeat;
@property UIButton *requireCodeButton;

-(id) initWithController:(RegisterStep1ViewController*)controller Type:(NSString*)type;

@end
