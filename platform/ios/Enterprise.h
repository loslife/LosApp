#import <Foundation/Foundation.h>

@interface Enterprise : NSObject

@property NSString *pk;
@property NSString *name;
@property int state;

-(id) initWithId:(NSString*)pk Name:(NSString*)name;
-(id) initWithId:(NSString*)pk Name:(NSString*)name state:(int)state;

@end
