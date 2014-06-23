#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+(NSString*) encodeWithBase64:(NSString*)plainText;
+(BOOL) isEmpty:(NSString*)origin;
+(NSString*) fromDate:(NSDate*)date;
+(NSString*) fromNumber:(NSNumber*)number;

@end
