#import "LosHttpHelper.h"

@implementation LosHttpHelper

+(BOOL) isNetworkAvailable
{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.yilos.com"];
    int status = [reach currentReachabilityStatus];
    return (status != NotReachable);
}

-(void) postSecure:(NSString*)urlString Data:(NSData*)postData completionHandler:(void(^)(NSData*, NSURLResponse*, NSError*))block
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:block];
    
    [task resume];
}

-(void) getSecure:(NSString*)urlString completionHandler:(void(^)(NSDictionary*))block
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        if(error){
            NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"error code: %li", (long)error.code);
            NSLog(@"parse response error, the http response body is: %@", body);
            block(nil);
            return;
        }
        
        NSDictionary *result;
        
        NSError *parseError = nil;
        result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
        if(parseError){
            NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"parse response error, the http response body is: %@", body);
            block(nil);
            return;
        }
        
        block(result);
    }];
    
    [task resume];
}

@end
