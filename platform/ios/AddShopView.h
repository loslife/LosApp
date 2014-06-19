#import <UIKit/UIKit.h>
#import "AddShopViewController.h"

@interface AddShopView : UIView<UITextFieldDelegate, UITextViewDelegate>

-(id) initWithController:(AddShopViewController*)controller;

@end
