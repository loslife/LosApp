#import <Foundation/Foundation.h>

@interface TimesHelper : NSObject

+(long long) now;
+(NSDate*) dateWithYear:(int)year month:(int)month day:(int)day;
+(NSTimeInterval) timeWithYear:(int)year month:(int)month day:(int)day;
+(NSDate*) firstDayOfWeek:(NSDate*)origin;
+(NSDate*) yesterdayOfDay:(NSDate*)origin;
+(NSDate*) previousMonthOfDate:(NSDate*)origin;
+(NSDate*) previousSundayOfDate:(NSDate*)origin;

@end
