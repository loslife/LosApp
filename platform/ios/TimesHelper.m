#import "TimesHelper.h"

@implementation TimesHelper

+(long long) now
{
    long long current = [[NSDate date] timeIntervalSince1970];
    return current * 1000;// 转换成毫秒
}

@end
