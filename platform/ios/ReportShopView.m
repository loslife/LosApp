#import "ReportShopView.h"
#import "PerformanceCompareView.h"
#import "LosStyles.h"
#import "ReportDateStatus.h"

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
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"经营业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(80, 11, 20, 18);
        self.button.tintColor = BLUE1;
        [self.button setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(refreshButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 140, 40)];
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:self.button];
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
        
        ReportDateStatus *dateStatus = [ReportDateStatus sharedInstance];
        DateDisplayType type = dateStatus.dateType;
        
        for(int i = 0; i < count; i++){
            
            BusinessPerformance *item = [dataSource itemAtIndex:i];
            
            NSString *value = [NSString stringWithFormat:@"￥%.1f", item.value];
            
            NSString *compareText;
            if(item.increased){
                if(type == DateDisplayTypeDay){
                    compareText = [NSString stringWithFormat:@"比昨日：+%.1f +%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }else if(type == DateDisplayTypeMonth){
                    compareText = [NSString stringWithFormat:@"比上月：+%.1f +%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }else{
                    compareText = [NSString stringWithFormat:@"比上周：+%.1f +%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }
            }else{
                if(type == DateDisplayTypeDay){
                    compareText = [NSString stringWithFormat:@"比昨日：-%.1f -%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }else if(type == DateDisplayTypeMonth){
                    compareText = [NSString stringWithFormat:@"比上月：-%.1f -%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }else{
                    compareText = [NSString stringWithFormat:@"比上周：-%.1f -%.f%%", item.compareToPrev, item.compareToPrevRatio * 100];
                }
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

@end
