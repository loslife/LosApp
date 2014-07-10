#import "ReportCustomView.h"
#import "ReportCustomViewController.h"
#import "LosLineChart.h"
#import "HorizontalLine.h"

@implementation ReportCustomView

-(id) initWithController:(id<ReportCustomerViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if(self){
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 40);
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentCenter;
        
        HorizontalLine *line = [[HorizontalLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        LosLineChart *chart = [[LosLineChart alloc] initWithFrame:CGRectMake(0, 141, 320, 427)];
        
        [self addSubview:label];
        [self addSubview:line];
        [self addSubview:chart];
    }
    return self;
}

@end
