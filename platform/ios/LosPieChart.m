#import "LosPieChart.h"

@implementation LosPieChartItem

-(id) initWithTitle:(NSString*)title Ratio:(double)ratio
{
    self = [super init];
    if(self){
        self.title = title;
        self.ratio = ratio;
    }
    return self;
}

@end

@implementation LosPieChart

{
    id<LosPieChartDelegate> myDelegate;
    CGPoint pieCenter;
    CGFloat radius;
    CGFloat drawedRatio;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosPieChartDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        
        myDelegate = delegate;
        
        pieCenter = CGPointMake(frame.size.width / 4, frame.size.height / 2);
        if(screenHeight == 568){
            radius =  frame.size.width / 8;
        }else{
            radius = frame.size.width / 12;
        }
        
        drawedRatio = 0;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    if(screenHeight == 568){
        CGContextSetLineWidth(context, 25.0);
    }else{
        CGContextSetLineWidth(context, 15.0);
    }
    
    NSUInteger count = [myDelegate pieItemCount];
    
    for(int i = 0; i < count; i++){
        
        LosPieChartItem *item = [myDelegate pieItemAtIndex:i];
        
        CGFloat startAngle = 2 * M_PI * drawedRatio;
        CGFloat endAngle = 2 * M_PI * (item.ratio + drawedRatio);
        drawedRatio += item.ratio;
        
        CGContextSetStrokeColorWithColor(context, [myDelegate colorAtIndex:i].CGColor);
        CGContextAddArc(context, pieCenter.x, pieCenter.y, radius, startAngle, endAngle, 0);
        
        CGContextDrawPath(context, kCGPathStroke);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(160, 25 + i * 20, 10, 10)];
        label.backgroundColor = [myDelegate colorAtIndex:i];
        [self addSubview:label];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(180, 20 + i * 20, 140, 20)];
        title.textAlignment = NSTextAlignmentLeft;
        title.text = item.title;
        title.font = [UIFont systemFontOfSize:12];
        [self addSubview:title];
    }
}

@end
