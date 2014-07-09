#import "ReportShopView.h"
#import "PerformanceCompareView.h"
#import "ReportShopViewController.h"
#import "HorizontalLine.h"

@implementation ReportShopView

{
    id<ReportShopViewDataSource> dataSource;
    UILabel *total;
    LosPieChart *pie;
    UIView *footer;
}

-(id) initWithController:(id<ReportShopViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if (self) {
    
        dataSource = controller;
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.text = @"经营业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        HorizontalLine *line = [[HorizontalLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:(ReportShopViewController*)controller];
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
    pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:(ReportShopViewController*)dataSource];
    pie.backgroundColor = [UIColor whiteColor];
    [self addSubview:pie];
    
    for(UIView *temp in footer.subviews){
        [temp removeFromSuperview];
    }
    
    NSUInteger count = [dataSource itemCount];
    for(int i = 0; i < count; i++){
        
        BusinessPerformance *item = [dataSource itemAtIndex:i];
        
        NSString *value = [NSString stringWithFormat:@"￥%f", item.value];
        
        NSString *compareText;
        if(item.increased){
            compareText = [NSString stringWithFormat:@"比昨日：+%f +%f%%", item.compareToPrev, item.compareToPrevRatio];
        }else{
            compareText = [NSString stringWithFormat:@"比昨日：-%f -%f%%", item.compareToPrev, item.compareToPrevRatio];
        }
        
        PerformanceCompareView *label = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 50 * i + 10, 320, 40) Title:item.title CompareText:compareText Value:value Increase:item.increased];
        [footer addSubview:label];
    }
}

@end
