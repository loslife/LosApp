#import <Foundation/Foundation.h>

@interface EmployeePerformance : NSObject

@property(nonatomic,copy) NSString *pk;
@property(nonatomic,copy) NSNumber *total;
@property(nonatomic,copy) NSString *employeeName;

-(id) initWithPk:(NSString*)pk Total:(NSNumber*)total Name:(NSString*)name;

@end
