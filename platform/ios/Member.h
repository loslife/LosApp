#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,copy) NSString *pk;
@property(nonatomic,copy) NSString *name;
@property NSInteger sectionNumber;

-(id) initWithPk:(NSString*)pk Name:(NSString*)name;

@end
