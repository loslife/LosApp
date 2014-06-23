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

+(NSString*) fromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    return [dateFormatter stringFromDate:date];
}

+(NSString*) fromNumber:(NSNumber*)number
{
    if((NSNull*)number == [NSNull null]){
        return @"";
    }
    
    if(!number){
        return @"";
    }
    
    NSTimeInterval millis = [number doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millis];
    return [self fromDate:date];
}

@end
