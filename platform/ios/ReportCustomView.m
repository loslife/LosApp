#import "ReportCustomView.h"
#import "LosLineChart.h"

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
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        summary = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
        summary.text = [NSString stringWithFormat:@"会员%lu人次 散客%lu人次", [dataSource memberCount], [dataSource walkinCount]];
        summary.textAlignment = NSTextAlignmentRight;
        summary.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:summary];
        
        [self addSubview:header];
        [self addDataView];
    }
    return self;
}

-(void) reload
{
    NSString *title = [NSString stringWithFormat:@"会员%lu人次 散客%lu人次", [dataSource memberCount], [dataSource walkinCount]];
    summary.text = title;

    [scroll removeFromSuperview];
    [self addDataView];
}

-(void) addDataView
{
    if([dataSource hasData]){
        
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 375)];
        
        CGFloat contentHeight = ([dataSource itemCount] + 1) * 40;
        scroll.contentSize = CGSizeMake(320, contentHeight);
        
        LosLineChart *chart = [[LosLineChart alloc] initWithFrame:CGRectMake(0, 0, 320, 0) dataSource:dataSource];
        [scroll addSubview:chart];
        
        [self addSubview:scroll];
    }
}

@end
