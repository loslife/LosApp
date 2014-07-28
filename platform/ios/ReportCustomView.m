#import "ReportCustomView.h"
#import "LosLineChart.h"
#import "ReportDateStatus.h"
#import "LosStyles.h"

@implementation ReportCustomView

{
    id<ReportCustomerViewDataSource, LosLineChartDataSource> dataSource;
    
    UILabel *summary;
    UIScrollView *scroll;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportCustomerViewDataSource, LosLineChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if(self){
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(60, 11, 20, 18);
        self.button.tintColor = BLUE1;
        [self.button setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(refreshButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
        
        summary = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
        summary.textAlignment = NSTextAlignmentRight;
        summary.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:self.button];
        [header addSubview:summary];
        
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
    
    summary.text = [NSString stringWithFormat:@"会员%lu人次 散客%lu人次", [dataSource memberCount], [dataSource walkinCount]];
    
    [scroll removeFromSuperview];
    
    if([dataSource hasData]){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        CGFloat mainHeight = screenHeight - 193;
        
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, mainHeight)];
        
        CGFloat contentHeight = ([dataSource itemCount] + 1) * 40;
        scroll.contentSize = CGSizeMake(320, contentHeight);
        
        LosLineChart *chart = [[LosLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 0) dataSource:dataSource];
        [scroll addSubview:chart];
        
        [self addSubview:scroll];
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        if(status.dateType == DateDisplayTypeDay){
            [scroll setContentOffset:CGPointMake(0, 360) animated:YES];
        }
    }
}

@end
