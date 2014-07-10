#import "LosLineChart.h"

@interface GridView : UIView

-(id) initWithCenter:(CGPoint)position title:(NSString*)title color:(UIColor*)color;

@end

@implementation GridView

-(id) initWithCenter:(CGPoint)position title:(NSString*)title color:(UIColor*)color
{
    self = [super init];
    
    if(self){
        
        self.frame = CGRectMake(0, 0, 40, 40);
        self.center = CGPointMake(position.x + 15, position.y);
        
        UILabel *grid = [[UILabel alloc] init];
        grid.frame = CGRectMake(0, 15, 10, 10);
        grid.backgroundColor = color;
        
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 40)];
        text.textAlignment = NSTextAlignmentCenter;
        text.text = title;
        text.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:grid];
        [self addSubview:text];
    }
    
    return self;
}

@end

@implementation LosLineChartItem

-(id) initWithTitle:(NSString*)yAxisTitle value:(int)value order:(int)order
{
    self = [super init];
    if(self){
        self.yAxisTitle = yAxisTitle;
        self.value = value;
        self.order = order;
    }
    return self;
}

@end

@implementation LosLineChart

{
    id<LosLineChartDataSource> dataSource;
    CGPoint anchorPoint;
    CGFloat insets;
}

-(id) initWithFrame:(CGRect)frame dataSource:(id<LosLineChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataSource = ds;
        
        anchorPoint = CGPointMake(60, 40);
        insets = 40;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, .1f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Y轴
    CGContextMoveToPoint(context, anchorPoint.x, anchorPoint.y);
    CGContextAddLineToPoint(context, anchorPoint.x, 400);
    CGContextStrokePath(context);
    
    // X轴
    CGContextMoveToPoint(context, anchorPoint.x, anchorPoint.y);
    CGContextAddLineToPoint(context, 300, anchorPoint.y);
    CGContextStrokePath(context);
    
    NSUInteger sectionValue = [dataSource valuePerSection];
    
    // X轴title
    for(int i = 0; i < 6; i++){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x + insets * i, anchorPoint.y - 40, insets, insets)];
        label.textAlignment = NSTextAlignmentCenter;
        NSString *title = [NSString stringWithFormat:@"%lu", sectionValue * i];
        label.text = title;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        [self addSubview:label];
    }
    
    NSUInteger max = sectionValue * 5;
    CGFloat lengthPerValue = insets * 5 / max;
    NSUInteger count = [dataSource itemCount];
    
    for(int i = 0; i < count; i++){
        
        LosLineChartItem *item = [dataSource itemAtIndex:i];
        
        // Y轴title
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + insets * i, insets, insets)];
        yAxisLabel.textAlignment = NSTextAlignmentLeft;
        yAxisLabel.text = item.yAxisTitle;
        yAxisLabel.font = [UIFont systemFontOfSize:14];
        yAxisLabel.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        [self addSubview:yAxisLabel];
        
        CGPoint center = CGPointMake(anchorPoint.x + (item.value * lengthPerValue) + (insets / 2), anchorPoint.y + insets * i + (insets / 2));
        
        // 折线端点
        if(i == 0){
            CGContextMoveToPoint(context, center.x, center.y);
        }else{
            CGContextAddLineToPoint(context, center.x, center.y);
        }
        
        // 小方格
        NSString *title = [NSString stringWithFormat:@"%d人", item.value];
        
        int order = item.order;
        UIColor *color;
        if(order == 1){
            color = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:75/255.0f alpha:1.0f];
        }else if(order == 2){
            color = [UIColor colorWithRed:252/255.0f green:167/255.0f blue:136/255.0f alpha:1.0f];
        }else if(order == 3){
            color = [UIColor colorWithRed:254/255.0f green:207/255.0f blue:190/255.0f alpha:1.0f];
        }else{
            color = [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f];
        }
        
        GridView *grid = [[GridView alloc] initWithCenter:center title:title color:color];
        [self addSubview:grid];
    }
    
    CGContextStrokePath(context);
}

@end
