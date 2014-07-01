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

@end
