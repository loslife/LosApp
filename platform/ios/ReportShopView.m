#import "ReportShopView.h"
#import "PerformanceCompareView.h"

@implementation ReportShopView

{
    id<ReportShopViewDataSource, LosPieChartDelegate> dataSource;
    
    UILabel *total;
    UIView *main;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportShopViewDataSource, LosPieChartDelegate>)ds
{
    self = [super initWithFrame:frame];
    if (self) {
    
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text = @"经营业绩";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
    
    total = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
    total.text = [dataSource total];
    total.textAlignment = NSTextAlignmentRight;
    total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
    
    [header addSubview:label];
    [header addSubview:total];
    
    [self addSubview:header];
    [self addDataView];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 20, 39.5);
    CGContextAddLineToPoint(ctx, 300, 39.5);
    CGContextStrokePath(ctx);
}

-(void) reload
{
    total.text = [dataSource total];
    
    [main removeFromSuperview];
    [self addDataView];
}

-(void) addDataView
{
    if([dataSource hasData]){
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 375)];
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 0, 320, 160) Delegate:dataSource];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 10)];
        bar.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 170, 320, 205)];
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
        
        [main addSubview:pie];
        [main addSubview:bar];
        [main addSubview:footer];
        
        [self addSubview:main];
    }
}

@end
