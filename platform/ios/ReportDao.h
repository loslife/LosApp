#import <Foundation/Foundation.h>

@interface ReportDao : NSObject

-(NSMutableArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) batchInsertEmployeePerformance:(NSArray*)array type:(NSString*)type;

-(NSMutableArray*) queryBusinessPerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) insertBusinessPerformance:(NSDictionary*)entity type:(NSString*)type;
-(int) countBusinessPerformance:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;

-(NSArray*) queryServicePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) batchInsertServicePerformance:(NSArray*)array type:(NSString*)type;

-(NSMutableArray*) queryCustomerCountByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) batchInsertCustomerCount:(NSArray*)array type:(NSString*)type;

-(NSMutableArray*) queryIncomeByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(void) insertIncome:(NSDictionary*)entity type:(NSString*)type;

@end
