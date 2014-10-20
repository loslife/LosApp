#import <Foundation/Foundation.h>
#import "Member.h"

@protocol ContactDataSourceDelegate <NSObject>

-(void) memberTapped:(Member*)member;

@end

@interface ContactDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property id<ContactDataSourceDelegate> delegate;

+(ContactDataSource*) sharedInstance;

-(void) loadFromDatabaseWithEnterpriseId:(NSString*)enterpriseId completionHandler:(void(^)(NSUInteger count))block;
-(void) loadFromServiceWithEnterpriseId:(NSString*)enterpriseId countHandler:(void(^)(NSUInteger count))countHandler completionHandler:(void(^)(NSUInteger count))completionHandler;
-(void) refreshWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)(int count))block;
-(void) searchWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)())block;
-(int) countMembers:(NSString*)enterpriseId;

@end
