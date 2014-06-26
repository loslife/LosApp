#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+(BOOL) isEmpty:(NSString*)origin;
+(NSString*) fromDate:(NSDate*)date;
+(NSString*) fromNumber:(NSNumber*)number;
+(BOOL) isPhone:(NSString*)phone;

@end
