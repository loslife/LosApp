#import "ReportShopView.h"
#import "PerformanceCompareView.h"
#import "LosStyles.h"

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
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"经营业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 180, 40)];
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
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 20, 39.5);
    CGContextAddLineToPoint(ctx, 300, 39.5);
    CGContextStrokePath(ctx);
    
    total.text = [dataSource total];
    
    [main removeFromSuperview];
    
    if([dataSource hasData]){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        CGFloat mainHeight = screenHeight - 193;
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, mainHeight)];
        
        CGFloat pieHeight = round(mainHeight * 0.4);
        CGFloat footerHeight = mainHeight - pieHeight - 10;
        
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
            
            NSString *value = [NSString stringWithFormat:@"￥%.1f", item.value];
            
            NSString *compareText;
            if(item.increased){
                compareText = [NSString stringWithFormat:@"比昨日：+%.1f +%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
            }else{
                compareText = [NSString stringWithFormat:@"比昨日：-%.1f -%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
            }
            
            PerformanceCompareView *label = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, itemHeight * i, 320, itemHeight) Title:item.title CompareText:compareText Value:value Increase:item.increased];
            [footer addSubview:label];
        }
        
        [main addSubview:pie];
        [main addSubview:bar];
        [main addSubview:footer];
        
        [self addSubview:main];
    }
}

-(void) reload
{
    [self setNeedsDisplay];
}

@end
