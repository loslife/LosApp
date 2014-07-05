#import "ReportShopView.h"

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
        
        LosCircleItem *item1 = [[LosCircleItem alloc] initWithTitle:@"hehe" Ratio:0.3];
        LosCircleItem *item2 = [[LosCircleItem alloc] initWithTitle:@"haha" Ratio:0.3];
        LosCircleItem *item3 = [[LosCircleItem alloc] initWithTitle:@"xixi" Ratio:0.4];
        [items addObject:item1];
        [items addObject:item2];
        [items addObject:item3];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        header.text = @"经营业绩：￥4300";
        header.textAlignment = NSTextAlignmentLeft;
        
        MyLine *line = [[MyLine alloc] initWithFrame:CGRectMake(0, 140, 320, 1)];
        
        LosCircleChart *circle = [[LosCircleChart alloc] initWithFrame:CGRectMake(0, 141, 320, 180) Delegate:self];
        circle.backgroundColor = [UIColor whiteColor];
        
        UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 321, 320, 247)];
        footer.text = @"列表在此";
        footer.textAlignment = NSTextAlignmentLeft;
        footer.backgroundColor = [UIColor greenColor];
        
        [self addSubview:header];
        [self addSubview:line];
        [self addSubview:circle];
        [self addSubview:footer];
    }
    return self;
}

-(int) itemCount
{
    return 3;
}

-(LosCircleItem*) itemAtIndex:(int)index
{
    return [items objectAtIndex:index];
}

-(UIColor*) colorAtIndex:(int)index
{
    if(index == 0){
        return [UIColor redColor];
    }else if(index == 1){
        return [UIColor yellowColor];
    }else{
        return [UIColor blueColor];
    }
}

@end
