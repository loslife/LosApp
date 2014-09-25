#import "ReportShopView.h"
#import "PerformanceCompareView.h"
#import "LosStyles.h"
#import "ReportDateStatus.h"

@implementation ReportShopView

{
    id<ReportShopViewDataSource, LosPieChartDelegate> dataSource;
    
    UILabel *total;
    UIView *main;
    
    CGFloat mainHeight;
    CGFloat headerHeight;
    CGFloat pieHeight;
    CGFloat barHeight;
    CGFloat footerHeight;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportShopViewDataSource, LosPieChartDelegate>)ds
{
    self = [super initWithFrame:frame];
    if (self) {
    
        headerHeight = 40;
        mainHeight = frame.size.height - headerHeight;
        pieHeight = round(mainHeight * 0.4);
        barHeight = 10;
        footerHeight = mainHeight - pieHeight - 10;
        
        self.contentSize = CGSizeMake(320, frame.size.height + 10);
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"经营业绩";
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
    total.text = [dataSource total];
    
    [main removeFromSuperview];
    
    if([dataSource hasData]){
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, mainHeight)];
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 0, 320, pieHeight) Delegate:dataSource];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, pieHeight, 320, 10)];
        bar.backgroundColor = GRAY1;
        bar.layer.borderColor = GRAY2.CGColor;
        bar.layer.borderWidth = .5f;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, pieHeight + 10, 320, footerHeight)];
        
        NSUInteger count = [dataSource itemCount];
        CGFloat itemHeight = footerHeight / count;
        
        for(int i = 0; i < count; i++){
            
            BusinessPerformance *item = [dataSource itemAtIndex:i];
            
            PerformanceCompareView *label = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, itemHeight * i + 10, 320, itemHeight) Title:item.title Compare:item.compareToPrev CompareRatio:item.compareToPrevRatio Value:item.value Increase:item.increased];
            [footer addSubview:label];
        }
        
        [main addSubview:pie];
        [main addSubview:bar];
        [main addSubview:footer];
        
        [self addSubview:main];
    }
}

@end
