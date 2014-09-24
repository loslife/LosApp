#import <UIKit/UIKit.h>

@interface PerformanceCompareView : UIView

- (id)initWithFrame:(CGRect)frame Title:(NSString*)title Compare:(double)compare CompareRatio:(double)compareRatio Value:(double)value Increase:(BOOL)increase;

@end
