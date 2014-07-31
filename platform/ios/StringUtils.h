#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+(BOOL) isEmpty:(NSString*)origin;
+(NSString*) fromDate:(NSDate*)date format:(NSString*)format;
+(NSString*) fromNumber:(NSNumber*)number format:(NSString*)format;
+(BOOL) isPhone:(NSString*)phone;

@end
