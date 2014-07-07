#import <Foundation/Foundation.h>

@interface ReportDao : NSObject

-(NSArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;

@end
