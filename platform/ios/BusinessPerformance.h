#import <Foundation/Foundation.h>

@interface BusinessPerformance : NSObject

@property NSString *title;
@property NSUInteger value;
@property double ratio;
@property NSInteger compareToPrev;
@property double compareToPrevRatio;
@property BOOL increased;

-(id) initWithTitle:(NSString*)title Value:(NSUInteger)value Ratio:(double)ratio;

@end
