#import "StringUtils.h"
#import "NSData+Base64.h"

@implementation StringUtils

+(NSString*) encodeWithBase64:(NSString*)plainText
{
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedString];
}

@end
