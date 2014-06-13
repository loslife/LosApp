#import <Foundation/Foundation.h>
#import "LosHttpsBase.h"
#import "Reachability.h"

@interface LosHttpHelper : LosHttpsBase

+(BOOL) isNetworkAvailable;
-(void) postSecure:(NSString*)urlString Data:(NSData*)postData completionHandler:(void(^)(NSData*, NSURLResponse*, NSError*))block;
-(void) getSecure:(NSString*)urlString completionHandler:(void(^)(NSDictionary*))block;

@end
