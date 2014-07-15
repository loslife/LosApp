#import <UIKit/UIKit.h>
#import "AddShopViewController.h"
#import "EnterpriseListView.h"

@interface AddShopView : UIView<UITextFieldDelegate, UITextViewDelegate>

@property UITextField *phone;
@property UITextField *code;
@property UIButton *requireCodeButton;
@property EnterpriseListView *list;

-(id) initWithController:(AddShopViewController*)controller;

@end
