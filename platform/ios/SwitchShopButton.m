#import "SwitchShopButton.h"
#import "LosDao.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "StringUtils.h"
#import "Enterprise.h"

@implementation SwitchShopButton

{
    LosDao *dao;
    
    BOOL dropDownShow;
    LosDropDown *dropDown;
    
    id<SwitchShopButtonDelegate> myDelegate;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<SwitchShopButtonDelegate>)delegate;
{
    dao = [[LosDao alloc] init];
    dropDownShow = NO;
    myDelegate = delegate;
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setBackgroundImage:[UIImage imageNamed:@"switch_shop"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(switchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    return [super initWithCustomView:button];
}

-(void) switchButtonTapped
{
    if(dropDownShow){
        [self closeSwitchShopMenu];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        int count = [dao countEnterprises];
        
        if(count == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有店铺，请先关联" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSArray *enterprises = [dao queryAllEnterprises];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:1];
        
        for(Enterprise *enterprise in enterprises){
            if([StringUtils isEmpty:enterprise.name]){
                enterprise.name = @"我的店铺";
            }
            LosDropDownItem *item = [[LosDropDownItem alloc] initWithTitle:enterprise.name value:enterprise.pk];
            [items addObject:item];
        }
        
        dropDown = [[LosDropDown alloc] initWithFrame:CGRectMake(150, 70, 150, 28) MenuItems:items Delegate:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [[[UIApplication sharedApplication] keyWindow] addSubview:dropDown];
            
            [(UIButton*)self.customView setBackgroundImage:[UIImage imageNamed:@"switch_shop_close"] forState:UIControlStateNormal];
            dropDownShow = YES;
        });
    });
}

-(void) menuItemTapped:(NSString*)value
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([currentEnterpriseId isEqualToString:value]){
        [self closeSwitchShopMenu];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [UserData writeCurrentEnterprise:value];
        
        NSString *name = [dao queryEnterpriseNameById:value];
        if([StringUtils isEmpty:name]){
            name = @"我的店铺";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *controller = (UIViewController*)myDelegate;
            controller.navigationItem.title = name;
            [self closeSwitchShopMenu];
            
            [myDelegate enterpriseSelected:value];
        });
    });
}

-(void) closeSwitchShopMenu{
    
    if(!dropDownShow){
        return;
    }
    
    [dropDown removeFromSuperview];
    
    [(UIButton*)self.customView setBackgroundImage:[UIImage imageNamed:@"switch_shop"] forState:UIControlStateNormal];
    
    dropDownShow = NO;
}

@end
