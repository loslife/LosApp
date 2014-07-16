#import <Foundation/Foundation.h>

@interface EnterpriseDao : NSObject

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName;
-(void) batchInsertEnterprises:(NSArray*)enterprises;
-(int) countEnterprises;
-(NSArray*) queryAllEnterprises;
-(NSString*) queryEnterpriseNameById:(NSString*)pk;
-(int) querySyncCountById:(NSString*)enterpriseId;

@end
