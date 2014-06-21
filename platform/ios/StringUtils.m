#import "StringUtils.h"
#import "NSData+Base64.h"

@implementation StringUtils

+(NSString*) encodeWithBase64:(NSString*)plainText
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedString];
}

+(BOOL) isEmpty:(NSString*)origin
{
    if((NSNull*)origin == [NSNull null]){
        return YES;
    }
    
    if(origin == nil){
        return YES;
    }
    
    if([origin isEqualToString:@""]){
        return YES;
    }
    
    return NO;
}

@end
