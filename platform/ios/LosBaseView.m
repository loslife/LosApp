#import "LosBaseView.h"

@implementation LosBaseView

{
    id currentResponder;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void) resignOnTap
{
    [currentResponder resignFirstResponder];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    currentResponder = textField;
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
