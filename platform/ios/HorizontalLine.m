#import "HorizontalLine.h"

@implementation HorizontalLine

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), 0);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:202/255.0f green:211/255.0f blue:218/255.0f alpha:1.0f].CGColor);
    CGContextSetLineWidth(ctx, .1f);
    CGContextStrokePath(ctx);
}

@end
