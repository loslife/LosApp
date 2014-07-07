#import <Foundation/Foundation.h>

@interface BusinessPerformance : NSObject

@property NSString *title;
@property double value;
@property double ratio;
@property double compareToPrev;
@property double compareToPrevRatio;
@property BOOL increased;

-(id) initWithTitle:(NSString*)title Value:(double)value Ratio:(double)ratio;

@end
