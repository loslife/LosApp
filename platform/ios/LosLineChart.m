#import "LosLineChart.h"

@implementation LosLineChart

{
    id<LosLineChartDataSource> dataSource;
    CGPoint anchorPoint;
}

-(id) initWithFrame:(CGRect)frame dataSource:(id<LosLineChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        anchorPoint = CGPointMake(60, 40);
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextMoveToPoint(context, anchorPoint.x, anchorPoint.y);
    CGContextAddLineToPoint(context, anchorPoint.x, 400);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, anchorPoint.x, anchorPoint.y);
    CGContextAddLineToPoint(context, 300, anchorPoint.y);
    CGContextStrokePath(context);
    
    NSUInteger sectionValue = [dataSource valuePerSection];
    
    for(int i = 0; i < 6; i++){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x + 40 * i, anchorPoint.y - 40, 40, 40)];
        [label setTextAlignment:NSTextAlignmentCenter];
        NSString *title = [NSString stringWithFormat:@"%lu", sectionValue * i];
        [label setText:title];
        [self addSubview:label];
    }
    
    UILabel *y_label1 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y, 40, 40)];
    [y_label1 setTextAlignment:NSTextAlignmentCenter];
    [y_label1 setText:@"1"];
    [self addSubview:y_label1];
    
    UILabel *y_label2 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + 40, 40, 40)];
    [y_label2 setTextAlignment:NSTextAlignmentCenter];
    [y_label2 setText:@"2"];
    [self addSubview:y_label2];
    
    UILabel *y_label3 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + 80, 40, 40)];
    [y_label3 setTextAlignment:NSTextAlignmentCenter];
    [y_label3 setText:@"3"];
    [self addSubview:y_label3];
    
    UILabel *y_label4 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + 120, 40, 40)];
    [y_label4 setTextAlignment:NSTextAlignmentCenter];
    [y_label4 setText:@"4"];
    [self addSubview:y_label4];
    
    UILabel *y_label5 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + 160, 40, 40)];
    [y_label5 setTextAlignment:NSTextAlignmentCenter];
    [y_label5 setText:@"5"];
    [self addSubview:y_label5];
    
    UILabel *y_label6 = [[UILabel alloc]initWithFrame:CGRectMake(anchorPoint.x - 40, anchorPoint.y + 200, 40, 40)];
    [y_label6 setTextAlignment:NSTextAlignmentCenter];
    [y_label6 setText:@"6"];
    [self addSubview:y_label6];
    
	CGContextMoveToPoint(context, anchorPoint.x + 120 + 20, anchorPoint.y + 20);
    UILabel *point1 = [[UILabel alloc] init];
    point1.frame = CGRectMake(0, 0, 10, 10);
    point1.center = CGPointMake(anchorPoint.x + 120 + 20, anchorPoint.y + 20);
    point1.backgroundColor = [UIColor greenColor];
    [self addSubview:point1];
    
    CGContextAddLineToPoint(context, anchorPoint.x + 20, anchorPoint.y + 60);
    UILabel *point2 = [[UILabel alloc] init];
    point2.frame = CGRectMake(0, 0, 10, 10);
    point2.center = CGPointMake(anchorPoint.x + 20, anchorPoint.y + 40 + 20);
    point2.backgroundColor = [UIColor greenColor];
    [self addSubview:point2];
    
    CGContextAddLineToPoint(context, anchorPoint.x + 70, anchorPoint.y + 100);
    UILabel *point3 = [[UILabel alloc] init];
    point3.frame = CGRectMake(0, 0, 10, 10);
    point3.center = CGPointMake(anchorPoint.x + 70, anchorPoint.y + 100);
    point3.backgroundColor = [UIColor greenColor];
    [self addSubview:point3];
    
    CGContextAddLineToPoint(context, anchorPoint.x + 90, anchorPoint.y + 140);
    UILabel *point4 = [[UILabel alloc] init];
    point4.frame = CGRectMake(0, 0, 10, 10);
    point4.center = CGPointMake(anchorPoint.x + 90, anchorPoint.y + 140);
    point4.backgroundColor = [UIColor greenColor];
    [self addSubview:point4];
    
    CGContextAddLineToPoint(context, anchorPoint.x + 144, anchorPoint.y + 180);
    UILabel *point5 = [[UILabel alloc] init];
    point5.frame = CGRectMake(0, 0, 10, 10);
    point5.center = CGPointMake(anchorPoint.x + 144, anchorPoint.y + 180);
    point5.backgroundColor = [UIColor greenColor];
    [self addSubview:point5];
    
    CGContextAddLineToPoint(context, anchorPoint.x + 120, anchorPoint.y + 220);
    UILabel *point6 = [[UILabel alloc] init];
    point6.frame = CGRectMake(0, 0, 10, 10);
    point6.center = CGPointMake(anchorPoint.x + 120, anchorPoint.y + 220);
    point6.backgroundColor = [UIColor greenColor];
    [self addSubview:point6];
    
    CGContextStrokePath(context);
}

@end
