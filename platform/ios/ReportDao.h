#import <Foundation/Foundation.h>

@interface ReportDao : NSObject

-(NSMutableArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) batchInsertEmployeePerformance:(NSArray*)array type:(NSString*)type;
-(NSMutableArray*) queryBusinessPerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) insertBusinessPerformance:(NSDictionary*)entity type:(NSString*)type;

@end
