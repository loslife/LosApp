#import <Foundation/Foundation.h>
#import "ContactViewController.h"

@interface ContactDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

-(id) initWithController:(ContactViewController*)viewController;
-(void) loadFromDatabaseWithEnterpriseId:(NSString*)enterpriseId completionHandler:(void(^)(NSUInteger count))block;
-(void) loadFromServiceWithEnterpriseId:(NSString*)enterpriseId countHandler:(void(^)(NSUInteger count))countHandler completionHandler:(void(^)(NSUInteger count))completionHandler;
-(void) refreshWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)(int count))block;
-(void) searchWithEnterpriseId:(NSString*)enterpriseId searchText:(NSString*)searchText completionHandler:(void(^)())block;

@end
