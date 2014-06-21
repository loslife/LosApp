#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

+(NSString*) encodeWithBase64:(NSString*)plainText;
+(BOOL) isEmpty:(NSString*)origin;

@end
