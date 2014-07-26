#import "LosBarChart.h"

@implementation LosBarChart

{
    id<LosBarChartDataSource> dataSource;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<LosBarChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if(self){
        dataSource = ds;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    NSUInteger count = [dataSource rowCount];
    if(count == 0){
        return;
    }
    
    CGFloat lengthPerValue;
    
    int maxValue = [dataSource maxValue];
    if(maxValue != 0){
        lengthPerValue = 160.0 / maxValue;
    }else{
        lengthPerValue = 0;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 80, 15);
    CGContextAddLineToPoint(ctx, 80, rect.size.height - 5);
    CGContextStrokePath(ctx);
    
    for(int i = 0; i < count; i++){
        
        UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 10 + 40 * i, 320, 40)];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 40)];
        name.text = [dataSource nameAtIndex:i];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        name.font = [UIFont systemFontOfSize:14.0];
        
        double value = [dataSource valueAtIndex:i];
        CGFloat barLength = ceil(value * lengthPerValue);
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, barLength, 30)];
        if(i == 0){
            bar.backgroundColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:75/255.0f alpha:1.0f];
        }else if(i == 1){
            bar.backgroundColor = [UIColor colorWithRed:252/255.0f green:167/255.0f blue:136/255.0f alpha:1.0f];
        }else if(i == 2){
            bar.backgroundColor = [UIColor colorWithRed:254/255.0f green:207/255.0f blue:190/255.0f alpha:1.0f];
        }else{
            bar.backgroundColor = [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f];
        }
        
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(80 + barLength, 0, 80, 40)];
        money.text = [NSString stringWithFormat:@"￥%.1f", value];
        money.textAlignment = NSTextAlignmentLeft;
        money.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        money.font = [UIFont systemFontOfSize:14.0];
        
        [row addSubview:name];
        [row addSubview:bar];
        [row addSubview:money];
        
        [self addSubview:row];
    }
}

@end
