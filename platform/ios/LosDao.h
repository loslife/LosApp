#import <Foundation/Foundation.h>

@interface LosDao : NSObject

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName;
-(void) batchInsertEnterprises:(NSArray*)enterprises;
-(void) batchUpdateMembers:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId;
-(NSArray*) queryEmployeePerformanceByDate:(NSDate*)date EnterpriseId:(NSString*)enterpriseId Type:(int)type;
-(int) countEnterprises;
-(NSArray*) queryAllEnterprises;
-(NSString*) queryEnterpriseNameById:(NSString*)pk;

@end
