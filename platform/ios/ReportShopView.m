#import "ReportShopView.h"
#import "PerformanceCompareView.h"

@interface MyLine : UIView

@end

@implementation MyLine

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), 0);
    CGContextStrokePath(ctx);
}

@end

@implementation ReportShopView

{
    UILabel *total;
}

-(id) initWithController:(ReportShopViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
    
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.text = @"经营业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
        total.text = @"￥4300.0";
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        MyLine *line = [[MyLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:controller];
        pie.backgroundColor = [UIColor whiteColor];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 301, 320, 10)];
        bar.backgroundColor = [UIColor colorWithRed:231/255.0f green:236/255.0f blue:240/255.0f alpha:1.0f];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 311, 320, 287)];
        PerformanceCompareView *c1 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 10, 320, 40) Title:@"服务业绩" CompareText:@"比昨日： -637" Value:@"￥2300.0"];
        PerformanceCompareView *c2 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 60, 320, 40) Title:@"卖品业绩" CompareText:@"比昨日： -637" Value:@"￥2300.0"];
        PerformanceCompareView *c3 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 110, 320, 40) Title:@"开卡业绩" CompareText:@"比昨日： -637" Value:@"￥2300.0"];
        PerformanceCompareView *c4 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 160, 320, 40) Title:@"充值业绩" CompareText:@"比昨日： -637" Value:@"￥2300.0"];
        [footer addSubview:c1];
        [footer addSubview:c2];
        [footer addSubview:c3];
        [footer addSubview:c4];
        
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
    total.text = @"2b";
}

@end
