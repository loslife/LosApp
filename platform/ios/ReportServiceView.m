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
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    CGFloat contentHeight = screenHeight - 153;
    
    CGFloat mainHeight = contentHeight - 40;
    CGFloat pieHeight = round(mainHeight * 0.4);
    CGFloat barHeight = 10;
    CGFloat footerHeight = [dataSource itemCount] == 0 ? 0: ([dataSource itemCount] + 1) * 40;
    
    if((40 + pieHeight + barHeight + footerHeight) > contentHeight){
        self.contentSize = CGSizeMake(320, 40 + pieHeight + barHeight + footerHeight);
    }else{
        self.contentSize = CGSizeMake(320, contentHeight + 10);
    }
    
    if([dataSource hasData]){
        
        main = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, pieHeight + barHeight + footerHeight)];
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 0, 320, pieHeight) Delegate:dataSource];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, pieHeight, 320, 10)];
        bar.backgroundColor = GRAY1;
        bar.layer.borderColor = GRAY2.CGColor;
        bar.layer.borderWidth = .5f;
        
        NSUInteger count = [dataSource itemCount];
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, pieHeight + 10, 320, footerHeight)];
        
        [main addSubview:pie];
        [main addSubview:bar];
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
