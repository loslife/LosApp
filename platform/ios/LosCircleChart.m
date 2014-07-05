#import "LosCircleChart.h"

@implementation LosCircleItem

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

@implementation LosCircleChart

{
    id<LosCircleDelegate> myDelegate;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosCircleDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self){
        myDelegate = delegate;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 20.0);
    
    int count = [myDelegate itemCount];
    
    CGFloat drawedRatio = 0;
    CGFloat x = rect.size.width / 2;
    CGFloat y = rect.size.height / 2;
    CGFloat radius =  x / 4;
    
    for(int i = 0; i < count; i++){
        
        LosCircleItem *item = [myDelegate itemAtIndex:i];
        
        CGContextSetStrokeColorWithColor(context, [myDelegate colorAtIndex:i].CGColor);
        
        CGFloat startAngle = 2 * PI * drawedRatio;
        CGFloat endAngle = 2 * PI * (item.ratio + drawedRatio);
        
        [item.title drawAtPoint:CGPointMake(160, 104) withAttributes:nil];
        
        CGContextAddArc(context, x, y, radius, startAngle, endAngle, 0);
        drawedRatio += item.ratio;
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
