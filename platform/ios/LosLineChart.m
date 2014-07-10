#import "LosLineChart.h"

@interface GridView : UIView

-(id) initWithCenter:(CGPoint)position title:(NSString*)title;

@end

@implementation GridView

-(id) initWithCenter:(CGPoint)position title:(NSString*)title
{
    self = [super init];
    
    if(self){
        
        self.frame = CGRectMake(0, 0, 40, 40);
        self.center = CGPointMake(position.x + 15, position.y);
        
        UILabel *grid = [[UILabel alloc] init];
        grid.frame = CGRectMake(0, 15, 10, 10);
        grid.backgroundColor = [UIColor greenColor];
        
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

-(id) initWithTitle:(NSString*)yAxisTitle value:(int)value
{
    self = [super init];
    if(self){
        self.yAxisTitle = yAxisTitle;
        self.value = value;
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
    
    CGContextSetLineWidth(context, 1.f);
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
        [label setTextAlignment:NSTextAlignmentCenter];
        NSString *title = [NSString stringWithFormat:@"%lu", sectionValue * i];
        [label setText:title];
        [self addSubview:label];
    }
    
    NSUInteger max = sectionValue * 5;
    CGFloat lengthPerValue = insets * 5 / max;
    NSUInteger count = [dataSource itemCount];
    
    for(int i = 0; i < count; i++){
        
        LosLineChartItem *item = [dataSource itemAtIndex:i];
        
        // Y轴title
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + insets * i, insets, insets)];
        [yAxisLabel setTextAlignment:NSTextAlignmentCenter];
        [yAxisLabel setText:item.yAxisTitle];
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
        GridView *grid = [[GridView alloc] initWithCenter:center title:title];
        [self addSubview:grid];
    }
    
    CGContextStrokePath(context);
}

@end
