#import <Foundation/Foundation.h>

@interface TimesHelper : NSObject

+(long long) now;
+(NSTimeInterval) timeWithYear:(int)year month:(int)month day:(int)day;

@end
