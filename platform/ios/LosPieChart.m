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
    CGFloat centerX;
    CGFloat centerY;
    CGFloat radius;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosPieChartDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self){
        
        myDelegate = delegate;
        
        centerX = frame.size.width / 2;
        centerY = frame.size.height / 2;
        radius =  frame.size.width / 8;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 20.0);
    
    int count = [myDelegate itemCount];
    
    CGFloat drawedRatio = 0;
    
    for(int i = 0; i < count; i++){
        
        LosPieChartItem *item = [myDelegate itemAtIndex:i];
        
        CGFloat startAngle = 2 * M_PI * drawedRatio;
        CGFloat endAngle = 2 * M_PI * (item.ratio + drawedRatio);
        drawedRatio += item.ratio;
        
        [item.title drawAtPoint:CGPointMake(160, 104) withAttributes:nil];
        
        CGContextSetStrokeColorWithColor(context, [myDelegate colorAtIndex:i].CGColor);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
