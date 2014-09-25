#import "ReportEmployeeView.h"
#import "LosStyles.h"

@implementation ReportEmployeeView

{
    id<ReportEmployeeViewDataSource, LosBarChartDataSource> dataSource;
    
    UILabel *total;
    UIView *main;
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
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, header.frame.size.height - 1, header.frame.size.width, .5);
        bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
        [header.layer addSublayer:bottomBorder];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 140, 40)];
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
    total.text = [NSString stringWithFormat:@"￥%.1f", [dataSource totalNumber]];

    [main removeFromSuperview];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    CGFloat contentHeight = screenHeight - 153;
    
    CGFloat headerHeight = 40;
    CGFloat chartHeight = [dataSource rowCount] * 40;
    
    if((headerHeight + chartHeight) > contentHeight){
        self.contentSize = CGSizeMake(320, headerHeight + chartHeight);
    }else{
        self.contentSize = CGSizeMake(320, contentHeight + 10);
    }
    
    if([dataSource hasData]){
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, chartHeight)];
        [self addSubview:main];
        
        LosBarChart *barChart = [[LosBarChart alloc] initWithFrame:CGRectMake(0, 0, 320, chartHeight) DataSource:dataSource];
        [main addSubview:barChart];
    }
}

@end
