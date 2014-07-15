#import <UIKit/UIKit.h>
#import "LosBaseView.h"
#import "AddShopViewController.h"
#import "EnterpriseListView.h"

@interface AddShopView : LosBaseView

@property UITextField *phone;
@property UITextField *code;
@property UIButton *requireCodeButton;
@property EnterpriseListView *list;

-(id) initWithController:(AddShopViewController*)controller;

@end
