#import "ReportIncomeDataSource.h"
#import "ReportDao.h"
#import "UserData.h"
#import "ReportDateStatus.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"

@implementation ReportIncomeDataSource

{
    Income *income;
    ReportDao *dao;
    LosHttpHelper *httpHelper;
}

-(id) init
{
    self = [super init];
    if(self){
        income = nil;
        dao = [[ReportDao alloc] init];
        httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(!flag){
        
        NSArray *array = [dao queryIncomeByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        [self assembleFromRecord1:[array objectAtIndex:0] Record2:[array objectAtIndex:1]];
        block(YES);
        
    }else{
        
        NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"income"];
        
        [httpHelper getSecure:url completionHandler:^(NSDictionary *response){
            
            NSDictionary *result = [response objectForKey:@"result"];
            
            NSDictionary *current = [result objectForKey:@"current"];
            NSDictionary *biz = [current objectForKey:@"tb_income_performance"];
            NSDictionary *record = [biz objectForKey:[status typeStr]];
            
            NSDictionary *prev = [result objectForKey:@"prev"];
            NSDictionary *biz2 = [prev objectForKey:@"tb_income_performance"];
            NSDictionary *record2 = [biz2 objectForKey:[status typeStr]];
            
            if([record objectForKey:@"_id"]){
                [dao insertIncome:record type:[status typeStr]];
            }
            
            if([record2 objectForKey:@"_id"]){
                [dao insertIncome:record2 type:[status typeStr]];
            }
            
            [self assembleFromRecord1:record Record2:record2];
            block(YES);
        }];
    }
}

-(void) assembleFromRecord1:(NSDictionary*)record1 Record2:(NSDictionary*)record2
{
    
}

#pragma mark - ReportIncomeViewDataSource

-(BOOL) hasData
{
    return YES;
}

-(Income*) domainModel
{
    return income;
}

#pragma mark - PieChart delegate

-(NSUInteger) pieItemCount
{
    return 2;
}

-(LosPieChartItem*) pieItemAtIndex:(int)index
{
    if(index == 0){
        NSString *title = [NSString stringWithFormat:@"收入 %.f%%", income.incomeRatio * 100];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:income.incomeRatio];
    }else{
        NSString *title = [NSString stringWithFormat:@"预付款 %.f%%", income.prepayRatio * 100];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:income.prepayRatio];
    }
}

-(UIColor*) colorAtIndex:(int)index
{
    if(index == 0){
        return [UIColor colorWithRed:126/255.0f green:207/255.0f blue:238/255.0f alpha:1.0f];
    }else{
        return [UIColor colorWithRed:112/255.0f green:221/255.0f blue:226/255.0f alpha:1.0f];
    }
}

@end
