#import "ReportEmployeeView.h"
#import "LosStyles.h"

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
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(80, 11, 20, 18);
        self.button.tintColor = BLUE1;
        [self.button setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(refreshButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 140, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:self.button];
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

@end
