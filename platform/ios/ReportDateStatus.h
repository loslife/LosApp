#import <Foundation/Foundation.h>
#import "LosTimePicker.h"

@interface ReportDateStatus : NSObject

+(ReportDateStatus*) sharedInstance;

-(NSDate*) date;
-(void) setDate:(NSDate*)newDate;

-(NSString*) typeStr;
-(DateDisplayType) dateType;
-(void) setDateType:(DateDisplayType)newType;

-(NSString*) yearStr;
-(NSString*) monthStr;
-(NSString*) dayStr;

-(int) year;
-(int) month;
-(int) day;

@end
