#import <Foundation/Foundation.h>

@interface ReportDao : NSObject

-(NSMutableArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) batchInsertEmployeePerformance:(NSArray*)array type:(NSString*)type;

@end
