#import "AddShopViewController.h"
#import "AddShopView.h"

@implementation AddShopViewController

-(void) loadView
{
    AddShopView *view = [[AddShopView alloc] initWithController:self];
    self.view = view;
}

@end
