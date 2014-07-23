#import "ReportEmployeeView.h"

@implementation ReportEmployeeView

{
    id<ReportEmployeeViewDataSource, LosBarChartDataSource> dataSource;
    
    UILabel *total;
    LosBarChart *barChart;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportEmployeeViewDataSource, LosBarChartDataSource>)ds
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
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text = @"员工业绩";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
    
    total = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    total.text = [NSString stringWithFormat:@"￥%.1f", [dataSource totalNumber]];
    total.textAlignment = NSTextAlignmentRight;
    total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
    
    [header addSubview:label];
    [header addSubview:total];
    
    [self addSubview:header];
    [self addDataView];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 20, 39.5);
    CGContextAddLineToPoint(ctx, 300, 39.5);
    CGContextStrokePath(ctx);
}

-(void) reload
{
    total.text = [NSString stringWithFormat:@"￥%.1f", [dataSource totalNumber]];
    
    [barChart removeFromSuperview];
    [self addDataView];
}

-(void) addDataView
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    
    if([dataSource hasData]){
        
        NSUInteger chartHeight = [dataSource rowCount] * 40;
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, screenHeight - 193)];
        scroll.contentSize = CGSizeMake(320, chartHeight);
        [self addSubview:scroll];
        
        barChart = [[LosBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, chartHeight) DataSource:dataSource];
        [scroll addSubview:barChart];
    }
}

@end
