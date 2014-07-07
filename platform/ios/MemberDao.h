#import <Foundation/Foundation.h>

@interface MemberDao : NSObject

-(void) batchUpdateMembers:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId;

@end
