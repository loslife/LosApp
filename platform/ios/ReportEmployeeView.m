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
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
        total.text = [NSString stringWithFormat:@"￥%d", [ds totalNumber]];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        [self addSubview:header];
        [self addDataView];
    }
    return self;
}

-(void) reload
{
    total.text = [NSString stringWithFormat:@"￥%d", [dataSource totalNumber]];
    
    [barChart removeFromSuperview];
    [self addDataView];
}

-(void) addDataView
{
    if([dataSource hasData]){
        barChart = [[LosBarChart alloc] initWithFrame:CGRectMake(0, 40, 320, 375) DataSource:dataSource];
        [self addSubview:barChart];
    }
}

@end
