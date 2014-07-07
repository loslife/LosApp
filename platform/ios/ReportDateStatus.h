#import <Foundation/Foundation.h>
#import "LosTimePicker.h"

@interface ReportDateStatus : NSObject

+(ReportDateStatus*) sharedInstance;
-(NSDate*) date;
-(void) setDate:(NSDate*)newDate;
-(DateDisplayType) dateType;
-(void) setDateType:(DateDisplayType)newType;
-(NSString*) yearStr;
-(NSString*) monthStr;
-(NSString*) dayStr;
-(NSString*) typeStr;

@end
