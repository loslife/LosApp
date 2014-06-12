#import <Foundation/Foundation.h>
#import "LosHttpsBase.h"

@interface LosHttpHelper : LosHttpsBase

-(void) postSecure:(NSString*)urlString Data:(NSData*)postData completionHandler:(void(^)(NSData*, NSURLResponse*, NSError*))block;
-(void) getSecure:(NSString*)urlString completionHandler:(void(^)(NSDictionary*))block;

@end
