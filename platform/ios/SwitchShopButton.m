#import "SwitchShopButton.h"
#import "LosDao.h"
#import "FMDB.h"
#import "PathResolver.h"
#import "StringUtils.h"
#import "Enterprise.h"

const CGFloat LosAnimationDuration = 0.25;

@implementation SwitchShopButton

{
    EnterpriseDao *dao;
    
    BOOL dropDownShow;
    LosDropDown *dropDown;
    
    NSMutableArray *dropDownItems;
    
    id<SwitchShopButtonDelegate> myDelegate;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<SwitchShopButtonDelegate>)delegate;
{
    dao = [[EnterpriseDao alloc] init];
    dropDownShow = NO;
    myDelegate = delegate;
    dropDownItems = [NSMutableArray arrayWithCapacity:1];
    
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
        
        [dropDownItems removeAllObjects];
        
        NSArray *enterprises = [dao queryDisplayEnterprises];
        
        UserData *userData = [UserData load];
        NSString *currentEnterpriseId = userData.enterpriseId;
        
        for(Enterprise *enterprise in enterprises){
            
            if([StringUtils isEmpty:enterprise.name]){
                enterprise.name = @"我的店铺";
            }
            
            BOOL selected = NO;
            if([enterprise.pk isEqualToString:currentEnterpriseId]){
                selected = YES;
            }
            LosDropDownItem *item = [[LosDropDownItem alloc] initWithTitle:enterprise.name value:enterprise.pk selected:selected];
            [dropDownItems addObject:item];
        }
        
        dropDown = [[LosDropDown alloc] initWithFrame:CGRectMake(150, 54, 0, 0) delegate:self];
    
        dispatch_async(dispatch_get_main_queue(), ^{

            [[[UIApplication sharedApplication] keyWindow] addSubview:dropDown];
            [dropDown setNeedsDisplay];

            [UIView animateWithDuration:LosAnimationDuration animations:^{
                self.customView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            
            dropDownShow = YES;
        });
    });
}

-(void) closeSwitchShopMenu{
    
    if(!dropDownShow){
        return;
    }
    
    [dropDown removeFromSuperview];
    
    [UIView animateWithDuration:LosAnimationDuration animations:^{
        self.customView.transform = CGAffineTransformIdentity;
    }];
    
    dropDownShow = NO;
}

#pragma mark - dropdown delegate

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

-(NSUInteger) itemCount
{
    return [dropDownItems count];
}

-(LosDropDownItem*) itemAtIndex:(NSUInteger)index
{
    return [dropDownItems objectAtIndex:index];
}

@end
