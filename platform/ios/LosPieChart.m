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
        
        myDelegate = delegate;
        
        pieCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        radius =  frame.size.width / 8;
        
        drawedRatio = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 25.0);
    
    int count = [myDelegate itemCount];
    
    for(int i = 0; i < count; i++){
        
        LosPieChartItem *item = [myDelegate itemAtIndex:i];
        
        CGFloat startAngle = 2 * M_PI * drawedRatio;
        CGFloat endAngle = 2 * M_PI * (item.ratio + drawedRatio);
        drawedRatio += item.ratio;
        
        CGFloat midAngle = (startAngle + endAngle) / 2;
        CGFloat cos_value = cos(midAngle);
        CGFloat x_offset = radius * (cos_value > 0 ? cos_value * 1.5 : cos_value * 3.6);
        CGFloat y_offset = radius * sin(midAngle) * 1.7;
        CGPoint textPoint = CGPointMake(pieCenter.x + x_offset, pieCenter.y + y_offset);
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,
         [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil];
        
        [item.title drawAtPoint:textPoint withAttributes:attrs];
        
        CGContextSetStrokeColorWithColor(context, [myDelegate colorAtIndex:i].CGColor);
        CGContextAddArc(context, pieCenter.x, pieCenter.y, radius, startAngle, endAngle, 0);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
