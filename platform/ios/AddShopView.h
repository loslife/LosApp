#import <UIKit/UIKit.h>
#import "AddShopViewController.h"

@interface AddShopView : UIView<UITextFieldDelegate, UITextViewDelegate>

@property UIButton *requireCodeButton;

-(id) initWithController:(AddShopViewController*)controller;

@end
