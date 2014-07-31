#import <Foundation/Foundation.h>
#import "Enterprise.h"

@interface EnterpriseDao : NSObject

-(void) insertEnterprisesWith:(NSString*)enterpriseId Name:(NSString*)enterpriseName account:(NSString*)account;
-(int) countEnterprises;
-(NSArray*) queryAllEnterprises;
-(NSString*) queryEnterpriseNameById:(NSString*)pk;
-(BOOL) querySyncFlagById:(NSString*)enterpriseId;
-(NSNumber*) queryLatestSyncTimeById:(NSString*)enterpriseId;
-(void) updateSyncFlagById:(NSString*)enterpriseId;
-(NSArray*) queryDisplayEnterprises;
-(void) updateDisplayById:(NSString*)enterpriseId value:(NSString*)value;
-(NSString*) queryAccountById:(NSString*)enterpriseId;

@end
