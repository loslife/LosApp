#import <Foundation/Foundation.h>

@interface Enterprise : NSObject

@property NSString *pk;
@property NSString *name;

-(id) initWithId:(NSString*)pk Name:(NSString*)name;

@end
