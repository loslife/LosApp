#import <Foundation/Foundation.h>

@interface ServicePerformance : NSObject

@property NSString *title;
@property double value;
@property double ratio;

-(id) initWithTitle:(NSString*)title Value:(double)value Ratio:(double)ratio;
-(id) initWithTitle:(NSString*)title value:(double)value;

@end
