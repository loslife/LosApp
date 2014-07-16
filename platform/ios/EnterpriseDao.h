#import <Foundation/Foundation.h>
#import "Enterprise.h"

@interface EnterpriseDao : NSObject

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName;
-(void) batchInsertEnterprises:(NSArray*)enterprises;
-(int) countEnterprises;
-(NSArray*) queryAllEnterprises;
-(NSString*) queryEnterpriseNameById:(NSString*)pk;
-(BOOL) querySyncFlagById:(NSString*)enterpriseId;
-(NSNumber*) queryLatestSyncTimeById:(NSString*)enterpriseId;
-(void) updateSyncFlagById:(NSString*)enterpriseId;

@end
