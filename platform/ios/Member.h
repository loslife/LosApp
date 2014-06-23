#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,copy) NSString *pk;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSNumber *birthday;
@property(nonatomic,copy) NSString *phoneMoble;
@property(nonatomic,copy) NSNumber *joinDate;
@property(nonatomic,copy) NSString *memberNo;

@property NSInteger sectionNumber;

-(id) initWithPk:(NSString*)pk Name:(NSString*)name Birthday:(NSNumber*)birthday Phone:(NSString*)phone JoinDate:(NSNumber*)joinDate MemberNo:(NSString*)memberNo;

@end
