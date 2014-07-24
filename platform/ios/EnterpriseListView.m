#import "EnterpriseListView.h"
#import "StringUtils.h"
#import "EnterpriseDao.h"

@implementation EnterpriseListView

{
    id<EnterpriseListViewDelegate> myDelegate;
    
    NSArray *records;
    EnterpriseDao *dao;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<EnterpriseListViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if(self){
        
        myDelegate = delegate;
        records = [NSArray array];
        dao = [[EnterpriseDao alloc] init];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    for(UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
    
    NSUInteger count = [records count];
    
    CGFloat contentHeight = 5 + 40 * count;
    self.contentSize = CGSizeMake(320, contentHeight);
    
    if(count == 0){
        
        self.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
        
        UILabel *none = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        none.text = @"您还未关联任何店铺，点击“添加关联”";
        none.textAlignment = NSTextAlignmentCenter;
        none.font = [UIFont systemFontOfSize:14];
        [self addSubview:none];
        
        return;
    }
    
    for(int i = 0; i < count; i++){
        
        if(i == 0){
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
            header.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
            [self addSubview:header];
        }
        
        Enterprise *enterprise = [records objectAtIndex:i];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(20, 5 + 40 * i, 280, 40)];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 14, 14)];
        if(enterprise.state == 1){
            leftView.image = [UIImage imageNamed:@"shop_attach"];
        }else{
            leftView.image = [UIImage imageNamed:@"shop_not_attach"];
        }
        
        UILabel *middleView = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 160, 40)];
        if([StringUtils isEmpty:enterprise.name]){
            middleView.text = @"我的店铺";
        }else{
            middleView.text = enterprise.name;
        }
        middleView.textAlignment = NSTextAlignmentLeft;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(200, 10, 80, 20);
        button.tintColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        button.layer.cornerRadius = 5;
        button.tag = i;
        if(enterprise.state == 1){
            [button setTitle:@"解除关联" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:75/255.0f alpha:1.0f];
            [button addTarget:self action:@selector(undoAttach:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button setTitle:@"恢复关联" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithRed:2/255.0f green:160/255.0f blue:221/255.0f alpha:1.0f];
            [button addTarget:self action:@selector(reAttach:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [item addSubview:leftView];
        [item addSubview:middleView];
        [item addSubview:button];
        item.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:item];
    }
}

-(void) reload
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        records = [dao queryAllEnterprises];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self setNeedsDisplay];
        });
    });
}

-(void) reAttach:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    Enterprise* item = [records objectAtIndex:(int)button.tag];
    [myDelegate reAttach:item.pk name:item.name];
}

-(void) undoAttach:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    Enterprise* item = [records objectAtIndex:(int)button.tag];
    [myDelegate undoAttach:item.pk name:item.name];
}

@end
