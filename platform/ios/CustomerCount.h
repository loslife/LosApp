#import <Foundation/Foundation.h>

@interface CustomerCount : NSObject

@property int totalMember;
@property int totalWalkin;
@property int count;
@property NSString *title;

-(id) initWithTotalMember:(int)member walkin:(int)walkin count:(int)count title:(NSString*)title;

@end
