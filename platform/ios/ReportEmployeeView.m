#import "ReportEmployeeView.h"

@implementation ReportEmployeeView

{
    id<ReportEmployeeViewDataSource, LosBarChartDataSource> dataSource;
    
    UILabel *total;
    UIScrollView *scroll;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportEmployeeViewDataSource, LosBarChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if(self){
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        [self addSubview:header];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 20, 39.5);
    CGContextAddLineToPoint(ctx, 300, 39.5);
    CGContextStrokePath(ctx);
    
    total.text = [NSString stringWithFormat:@"￥%.1f", [dataSource totalNumber]];

    [scroll removeFromSuperview];
    
    if([dataSource hasData]){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        NSUInteger chartHeight = [dataSource rowCount] * 40;
        
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, screenHeight - 193)];
        scroll.contentSize = CGSizeMake(320, chartHeight);
        [self addSubview:scroll];
        
        LosBarChart *barChart = [[LosBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, chartHeight) DataSource:dataSource];
        [scroll addSubview:barChart];
    }
}

-(void) reload
{
    [self setNeedsDisplay];
}

@end
