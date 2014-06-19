#import "AddShopViewController.h"
#import "AddShopView.h"

@implementation AddShopViewController

{
    NSTimer *timer;
    int resendCountdown;
}

-(void) loadView
{
    AddShopView *view = [[AddShopView alloc] initWithController:self];
    self.view = view;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void) viewDidAppear:(BOOL)animated
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    if(button.enabled){
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) requireVerificationCode
{
    // 发送验证码
    
    [self disableRequireCodeButton];
    [self startTick];
}

#pragma mark - private method

-(void) disableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = NO;
    button.backgroundColor = [UIColor whiteColor];
}

-(void) startTick
{
    resendCountdown = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        return;
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

-(void) enableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
}

@end
