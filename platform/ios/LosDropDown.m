#import "LosDropDown.h"
#import "LosStyles.h"

const CGFloat menuWidth = 160;
const CGFloat rowHeight = 44;

@implementation LosDropDownItem

-(id) initWithTitle:(NSString*)title value:(NSString*)value selected:(BOOL)selected
{
    self = [super init];
    if(self){
        self.title = title;
        self.value = value;
        self.selected = selected;
    }
    return self;
}

@end

@implementation LosDropDown

{
    id<LosDropDownDelegate> ds;
}

-(id) initWithFrame:(CGRect)frame delegate:(id<LosDropDownDelegate>)delegate
{
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;

    NSUInteger count = [delegate itemCount];
    CGFloat calculatedHeight = rowHeight * count + 10;
    
    self = [super initWithFrame:CGRectMake(x, y, menuWidth, calculatedHeight)];
    if(self){
        ds = delegate;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 139.5, 10);
    CGContextAddLineToPoint(ctx, 145, 0);
    CGContextAddLineToPoint(ctx, 150.5, 10);
    CGContextClosePath(ctx);
    
    CGContextSetLineWidth(ctx, .1f);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 10, menuWidth, rect.size.height - 10)];
    wrapper.backgroundColor = [UIColor whiteColor];
    wrapper.layer.cornerRadius = 5;
    wrapper.layer.borderWidth = 1;
    wrapper.layer.borderColor = GRAY1.CGColor;
    
    NSUInteger count = [ds itemCount];
    
    for(int i = 0;i < count; i++){
        
        LosDropDownItem *item = [ds itemAtIndex:i];
        
        BOOL selected = item.selected;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, (rowHeight - 4) / 2 + rowHeight * i, 4, 4)];
        if(selected){
            icon.image = [UIImage imageNamed:@"point_red"];
        }else{
            icon.image = [UIImage imageNamed:@"point_blue"];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, rowHeight * i, menuWidth - 20, rowHeight);
        [button setTitle:item.title forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if(selected){
            button.tintColor = RED1;
        }else{
            button.tintColor = BLUE1;
        }
        button.tag = i;
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [wrapper addSubview:icon];
        [wrapper addSubview:button];
    }
    
    [self addSubview:wrapper];
}

-(void) itemPressed:(id)sender
{
    UIButton* button = (UIButton*)sender;
    LosDropDownItem* item = [ds itemAtIndex:button.tag];
    [ds menuItemTapped:item.value];
}

@end
