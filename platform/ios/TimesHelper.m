#import "TimesHelper.h"

@implementation TimesHelper

+(long long) now
{
    long long current = [[NSDate date] timeIntervalSince1970];
    return current * 1000;// 转换成毫秒
}

+(NSTimeInterval) timeWithYear:(int)year month:(int)month day:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    NSDate *date = [calendar dateFromComponents:components];
    return [date timeIntervalSince1970];
}

@end
