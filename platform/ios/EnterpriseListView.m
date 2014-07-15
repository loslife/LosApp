#import "EnterpriseListView.h"

@implementation EnterpriseListView

{
    id<EnterpriseListViewDelegate> myDelegate;
    UIActivityIndicatorView *indicator;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<EnterpriseListViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self){
        
        myDelegate = delegate;
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(160, 100)];
        [self addSubview:indicator];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    [indicator startAnimating];
}

-(void) reload
{
    [indicator stopAnimating];
    
    for(UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
    
    NSUInteger count = [myDelegate count];
    
    if(count == 0){
        
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
        
        UILabel *none = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        none.text = @"您还未关联任何店铺，点击“添加关联”";
        none.textAlignment = NSTextAlignmentCenter;
        [self addSubview:none];
        
        return;
    }
    
    for(int i = 0; i < count; i++){
        
        if(i == 0){
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
            header.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
            [self addSubview:header];
        }
        
        Enterprise *enterprise = [myDelegate itemAtIndex:i];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(20, 5 + 40 * i, 280, 40)];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        leftView.image = [UIImage imageNamed:@"shop_attach"];
        
        UILabel *middleView = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 160, 40)];
        middleView.text = enterprise.name;
        middleView.textAlignment = NSTextAlignmentLeft;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(200, 10, 80, 20);
        [button setTitle:@"解除关联" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:244/255.0f green:196/255.0f blue:82/255.0f alpha:1.0f];
        button.tintColor = [UIColor whiteColor];
        
        [item addSubview:leftView];
        [item addSubview:middleView];
        [item addSubview:button];
        item.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:item];
    }
}

@end
