#import <Foundation/Foundation.h>
#import "ReportDao.h"
#import "LosHttpHelper.h"
#import "UserData.h"
#import "ReportDateStatus.h"
#import "StringUtils.h"
#import "LosAppUrls.h"

@interface ReportDataSourceBase : NSObject

@property NSMutableArray *records;
@property ReportDao *reportDao;
@property LosHttpHelper *httpHelper;;

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block;

@end
