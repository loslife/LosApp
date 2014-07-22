#import "TimesHelper.h"

@implementation TimesHelper

+(long long) now
{
    long long current = [[NSDate date] timeIntervalSince1970];
    return current * 1000;// 转换成毫秒
}

+(NSDate*) dateWithYear:(int)year month:(int)month day:(int)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    return [calendar dateFromComponents:components];
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

+(NSDate*) firstDayOfWeek:(NSDate*)origin
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:origin];
    
    if(components.weekday == 1){
        return origin;
    }
    
    components.weekday = 1;
    NSDate *sunday = [calendar dateFromComponents:components];
    return sunday;
}

+(NSDate*) previousSundayOfDate:(NSDate*)origin
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:origin];
    
    components.weekOfYear--;
    components.weekday = 1;
    NSDate *previousSunday = [calendar dateFromComponents:components];
    return previousSunday;
}

+(NSDate*) yesterdayOfDay:(NSDate*)origin
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:origin];
    components.day--;
    
    NSDate *yesterday = [calendar dateFromComponents:components];
    return yesterday;
}

+(NSDate*) previousMonthOfDate:(NSDate*)origin
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:origin];
    components.month--;
    
    return [calendar dateFromComponents:components];
}

@end
