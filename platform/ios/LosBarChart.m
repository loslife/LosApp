#import "LosBarChart.h"

@interface DividingLine : UIView

@end

@implementation DividingLine

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), 0);
    CGContextStrokePath(ctx);
}

@end

@interface VerticalLine : UIView

@end

@implementation VerticalLine

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, CGRectGetMaxY(rect));
    CGContextStrokePath(ctx);
}

@end

@implementation LosBarChart

{
    id<LosBarChartDataSource> delegate;
    UILabel *total;
    UIView *mainArea;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<LosBarChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if(self){
        
        delegate = ds;

        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        DividingLine *horizon = [[DividingLine alloc] initWithFrame:CGRectMake(20, 40, 280, 1)];
        
        mainArea = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 320, 427)];
        
        VerticalLine *vertical = [[VerticalLine alloc] initWithFrame:CGRectMake(60, 56, 1, 357)];
        
        [self addSubview:header];
        [self addSubview:horizon];
        [self addSubview:mainArea];
        [self addSubview:vertical];
    }
    return self;
}

-(void) reload
{
    total.text = [NSString stringWithFormat:@"￥%d", [delegate totalValue]];
    
    for(UIView *sub in mainArea.subviews){
        [sub removeFromSuperview];
    }
    
    NSUInteger count = [delegate rowCount];
    if(count == 0){
        return;
    }
    
    int maxValue = [delegate maxValue];
    CGFloat lengthPerValue = 180.0 / maxValue;

    for(int i = 0; i < count; i++){
        
        UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 40 * i, 320, 40)];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 40)];
        name.text = [delegate nameAtIndex:i];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        name.font = [UIFont systemFontOfSize:14.0];
        
        CGFloat barLength = [delegate valueAtIndex:i] * lengthPerValue;
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(61, 5, barLength, 30)];
        if(i == 0){
            bar.backgroundColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:75/255.0f alpha:1.0f];
        }else if(i == 1){
            bar.backgroundColor = [UIColor colorWithRed:252/255.0f green:167/255.0f blue:136/255.0f alpha:1.0f];
        }else if(i == 2){
            bar.backgroundColor = [UIColor colorWithRed:254/255.0f green:207/255.0f blue:190/255.0f alpha:1.0f];
        }else{
            bar.backgroundColor = [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f];
        }
        
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(61 + barLength, 0, 59, 40)];
        money.text = [NSString stringWithFormat:@"￥%d", [delegate valueAtIndex:i]];
        money.textAlignment = NSTextAlignmentLeft;
        money.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        money.font = [UIFont systemFontOfSize:14.0];
        
        [row addSubview:name];
        [row addSubview:bar];
        [row addSubview:money];
        
        [mainArea addSubview:row];
    }
}

@end
