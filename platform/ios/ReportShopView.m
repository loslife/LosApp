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
    NSMutableArray *items;
}

-(id) initWithController:(ReportShopViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
        
        items = [NSMutableArray arrayWithCapacity:1];
        
        LosPieChartItem *item1 = [[LosPieChartItem alloc] initWithTitle:@"卖品业绩28%" Ratio:0.28];
        LosPieChartItem *item2 = [[LosPieChartItem alloc] initWithTitle:@"充值业绩9.8%" Ratio:0.10];
        LosPieChartItem *item3 = [[LosPieChartItem alloc] initWithTitle:@"开卡业绩14.2%" Ratio:0.14];
        LosPieChartItem *item4 = [[LosPieChartItem alloc] initWithTitle:@"服务业绩48%" Ratio:0.48];
        [items addObject:item1];
        [items addObject:item2];
        [items addObject:item3];
        [items addObject:item4];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 40)];
        label.text = @"经营业绩";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 40)];
        total.text = @"￥4300.0";
        total.textAlignment = NSTextAlignmentRight;
        total.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        [header addSubview:label];
        [header addSubview:total];
        
        MyLine *line = [[MyLine alloc] initWithFrame:CGRectMake(20, 140, 280, 1)];
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 141, 320, 160) Delegate:self];
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

-(int) itemCount
{
    return 4;
}

-(LosPieChartItem*) itemAtIndex:(int)index
{
    return [items objectAtIndex:index];
}

-(UIColor*) colorAtIndex:(int)index
{
    if(index == 0){
        return [UIColor colorWithRed:227/255.0f green:110/255.0f blue:66/255.0f alpha:1.0f];
    }else if(index == 1){
        return [UIColor colorWithRed:249/255.0f green:208/255.0f blue:92/255.0f alpha:1.0f];
    }else if(index == 2){
        return [UIColor colorWithRed:85/255.0f green:214/255.0f blue:255/255.0f alpha:1.0f];
    }else{
        return [UIColor colorWithRed:134/255.0f green:121/255.0f blue:201/255.0f alpha:1.0f];
    }
}

@end
