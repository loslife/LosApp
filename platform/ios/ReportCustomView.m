#import "ReportCustomView.h"
#import "ReportCustomViewController.h"
#import "LosLineChart.h"
#import "HorizontalLine.h"

@implementation ReportCustomView

-(id) initWithController:(id<ReportCustomerViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if(self){
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        label.font = [UIFont systemFontOfSize:14];
        
        UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 40)];
        summary.textAlignment = NSTextAlignmentRight;
        summary.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        summary.text = @"会员5人次 散客16人次";
        summary.font = [UIFont systemFontOfSize:14];
        
        [header addSubview:label];
        [header addSubview:summary];

        HorizontalLine *line = [[HorizontalLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        LosLineChart *chart = [[LosLineChart alloc] initWithFrame:CGRectMake(0, 141, 320, 427) dataSource:(ReportCustomViewController*)controller];
        
        [self addSubview:header];
        [self addSubview:line];
        [self addSubview:chart];
    }
    return self;
}

@end
