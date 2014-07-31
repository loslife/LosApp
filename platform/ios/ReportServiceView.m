#import "ReportServiceView.h"
#import "LosPieChart.h"
#import "ServicePerformance.h"
#import "ServicePerformanceView.h"
#import "LosStyles.h"

@implementation ReportServiceView

{
    id<ReportServiceViewDataSource, LosPieChartDelegate> dataSource;
    
    UILabel *total;
    UIView *main;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportServiceViewDataSource, LosPieChartDelegate>)ds
{
    self = [super initWithFrame:frame];
    if (self) {
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"产品业绩";
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
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 0, 320, pieHeight) Delegate:dataSource];
        [main addSubview:pie];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, pieHeight, 320, 10)];
        bar.backgroundColor = GRAY1;
        bar.layer.borderColor = GRAY2.CGColor;
        bar.layer.borderWidth = .5f;
        [main addSubview:bar];
        
        NSUInteger count = [dataSource itemCount];
        
        CGFloat footerHeight = mainHeight - pieHeight - 10;
        UIScrollView *footer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pieHeight + 10, 320, footerHeight)];
        
        if(count == 0){
            footer.contentSize = CGSizeMake(320, 0);
        }else{
            footer.contentSize = CGSizeMake(320, 40 * (count + 1));
        }
        [main addSubview:footer];
        
        if(count != 0){
            
            UILabel *other = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 270, 40)];
            other.text = @"其他";
            other.textAlignment = NSTextAlignmentLeft;
            other.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
            [footer addSubview:other];
            
            for(int i = 0; i < count; i++){
                
                ServicePerformance *item = [dataSource itemAtIndex:i];
                
                NSString *value = [NSString stringWithFormat:@"￥%.1f", item.value];
                NSString *ratio = [NSString stringWithFormat:@"%.f%%", item.ratio * 100];
                NSString *title = [NSString stringWithFormat:@"%d.%@", i + 4, item.title];
                
                ServicePerformanceView *row = [[ServicePerformanceView alloc] initWithFrame:CGRectMake(20, 40 * (i + 1), 280, 40) title:title ratio:ratio value:value];
                
                [footer addSubview:row];
            }
        }
        
        [self addSubview:main];
    }
}

@end
