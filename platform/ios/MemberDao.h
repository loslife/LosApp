#import <Foundation/Foundation.h>

@interface MemberDao : NSObject

-(void) batchUpdateMembers:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId;
-(NSArray*) queryMembersByEnterpriseId:(NSString*)enterpriseId;
-(NSArray*) fuzzyQueryMembersByEnterpriseId:(NSString*)enterpriseId name:(NSString*)name;

@end
