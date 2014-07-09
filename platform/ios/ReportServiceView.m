#import "ReportServiceView.h"
#import "LosPieChart.h"
#import "HorizontalLine.h"
#import "ReportServiceViewController.h"
#import "ServicePerformance.h"
#import "ServicePerformanceView.h"

@implementation ReportServiceView

{
    id<ReportServiceViewDataSource> dataSource;
    UILabel *total;
    LosPieChart *pie;
    UIView *footer;
}

-(id) initWithController:(id<ReportServiceViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if (self) {
        
        dataSource = controller;
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.text = @"产品业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        HorizontalLine *line = [[HorizontalLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:(ReportServiceViewController*)controller];
        pie.backgroundColor = [UIColor whiteColor];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 301, 320, 10)];
        bar.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
        
        footer = [[UIView alloc] initWithFrame:CGRectMake(0, 311, 320, 287)];
        
        [self addSubview:header];
        [self addSubview:line];
        [self addSubview:pie];
        [self addSubview:bar];
        [self addSubview:footer];
    }
    return self;
}

-(void) reload
{
    total.text = [dataSource total];
    
    [pie removeFromSuperview];
    pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:(ReportServiceViewController*)dataSource];
    pie.backgroundColor = [UIColor whiteColor];
    [self addSubview:pie];
    
    for(UIView *temp in footer.subviews){
        [temp removeFromSuperview];
    }
    
    NSUInteger count = [dataSource itemCount];
    
    for(int i = 0; i < count; i++){
        
        ServicePerformance *item = [dataSource itemAtIndex:i];
        
        NSString *value = [NSString stringWithFormat:@"￥%f", item.value];
        NSString *ratio = [NSString stringWithFormat:@"%f%%", item.ratio];
        NSString *title = [NSString stringWithFormat:@"%d.%@", i + 4, item.title];
        
        ServicePerformanceView *row = [[ServicePerformanceView alloc] initWithFrame:CGRectMake(20, 40 * i + 10, 280, 40) title:title ratio:ratio value:value];
        
        [footer addSubview:row];
    }
}

@end
