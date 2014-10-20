#import "ReportCustomView.h"
#import "LosLineChart.h"
#import "ReportDateStatus.h"
#import "LosStyles.h"

@implementation ReportCustomView

{
    id<ReportCustomerViewDataSource, LosLineChartDataSource> dataSource;
    
    UILabel *summary;
    UIView *main;
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
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, header.frame.size.height - 1, header.frame.size.width, .5);
        bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
        [header.layer addSublayer:bottomBorder];
        
        summary = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
        summary.textAlignment = NSTextAlignmentRight;
        summary.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:summary];
        
        [self addSubview:header];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    summary.text = [NSString stringWithFormat:@"会员%ld人次 散客%ld人次", (long)[dataSource memberCount], (long)[dataSource walkinCount]];
    
    [main removeFromSuperview];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    CGFloat contentHeight = screenHeight - 153;
    
    CGFloat headerHeight = 40;
    CGFloat chartHeight = ([dataSource itemCount] + 1) * 40;
    
    if((headerHeight + chartHeight) > contentHeight){
        self.contentSize = CGSizeMake(320, headerHeight + chartHeight);
    }else{
        self.contentSize = CGSizeMake(320, contentHeight + 10);
    }
    
    if([dataSource hasData]){
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, chartHeight)];
        [self addSubview:main];
        
        LosLineChart *chart = [[LosLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 0) dataSource:dataSource];
        [main addSubview:chart];
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        if(status.dateType == DateDisplayTypeDay){
            [self setContentOffset:CGPointMake(0, 360) animated:YES];
        }else{
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

@end
