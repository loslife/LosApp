#import "ReportDataSourceBase.h"

@implementation ReportDataSourceBase

-(id) init
{
    self = [super init];
    if(self){
        self.records = [NSMutableArray arrayWithCapacity:1];
        self.reportDao = [[ReportDao alloc] init];
        self.httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
