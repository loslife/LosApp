#import "StringUtils.h"

@implementation StringUtils

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

+(NSString*) fromDate:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

+(NSString*) fromNumber:(NSNumber*)number format:(NSString*)format
{
    if((NSNull*)number == [NSNull null]){
        return @"";
    }
    
    if(!number){
        return @"";
    }
    
    NSTimeInterval millis = [number doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millis];
    return [self fromDate:date format:format];
}

+(BOOL) isPhone:(NSString*)phone
{
    NSString *phoneRegex = @"^((13)|(15)|(18))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

@end
