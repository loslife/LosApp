#import "ReportDateStatus.h"

@implementation ReportDateStatus

{
    NSDate *date;
    DateDisplayType dateType;
}

-(id) init
{
    self = [super init];
    if(self){
        date = [NSDate date];
        dateType = DateDisplayTypeDay;
    }
    return self;
}

-(NSDate*) date
{
    return date;
}

-(void) setDate:(NSDate*)newDate
{
    date = newDate;
}

-(DateDisplayType) dateType
{
    return dateType;
}

-(void) setDateType:(DateDisplayType)newType
{
    dateType = newType;
}

+(ReportDateStatus*) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(NSString*) yearStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:date];
    
    NSInteger year = [components year];
    return [NSString stringWithFormat:@"%ld", year];
}

-(NSString*) monthStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    NSInteger month = [components month];
    return [NSString stringWithFormat:@"%ld", month];
}

-(NSString*) dayStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:date];
    
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%ld", day];
}

-(NSString*) typeStr
{
    if(dateType == DateDisplayTypeDay){
        return @"day";
    }else if(dateType == DateDisplayTypeMonth){
        return @"month";
    }else{
        return @"week";
    }
}

-(int) year
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:date];
    
    return (int)[components year];
}

-(int) month
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    return (int)[components month];
}

-(int) day
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay fromDate:date];
    
    return (int)[components day];
}

@end
