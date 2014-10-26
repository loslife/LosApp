#import "ReportIncomeDataSource.h"
#import "ReportDao.h"
#import "UserData.h"
#import "ReportDateStatus.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"

@interface CompareResult : NSObject

@property BOOL increased;
@property double compareToPrev;
@property double compareToPrevRatio;

@end

@implementation CompareResult

-(id) initWithIncreased:(BOOL)increased number:(double)number ratio:(double)ratio
{
    self = [super init];
    if(self){
        self.increased = increased;
        self.compareToPrev = number;
        self.compareToPrevRatio = ratio;
    }
    return self;
}

@end

@implementation ReportIncomeDataSource

{
    Income *income;
    ReportDao *dao;
    LosHttpHelper *httpHelper;
    BOOL support;
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
        
        // 参照经营业绩，判断美业管家是否版本太低
        if([[array objectAtIndex:0] objectForKey:@"_id"]){
            support = YES;
        }else{
            int count = [dao countBusinessPerformance:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
            support = (count == 0);
        }
        
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
            
            // 参照经营业绩，判断美业管家是否版本太低
            if([record objectForKey:@"_id"]){
                
                support = YES;
                block(YES);
            }else{
                
                NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], [status typeStr], @"business"];
                
                [httpHelper getSecure:url completionHandler:^(NSDictionary *response){
                    
                    NSDictionary *result = [response objectForKey:@"result"];
                    
                    NSDictionary *current = [result objectForKey:@"current"];
                    NSDictionary *biz = [current objectForKey:@"tb_biz_performance"];
                    NSDictionary *record = [biz objectForKey:[status typeStr]];
                    
                    if([record objectForKey:@"_id"]){
                        support = NO;
                    }else{
                        support = YES;
                    }
                    
                    block(YES);
                }];
            }
        }];
    }
}

-(void) assembleFromRecord1:(NSDictionary*)record1 Record2:(NSDictionary*)record2
{
    income = nil;
    
    if(![record1 objectForKey:@"_id"]){
        return;
    }
    
    income = [[Income alloc] init];
    income.serviceBank = [[record1 objectForKey:@"service_bank"] doubleValue];
    income.serviceCash = [[record1 objectForKey:@"service_cash"] doubleValue];
    income.productBank = [[record1 objectForKey:@"product_bank"] doubleValue];
    income.productCash = [[record1 objectForKey:@"product_cash"] doubleValue];
    income.card = [[record1 objectForKey:@"card"] doubleValue];
    income.totalIncome = [[record1 objectForKey:@"total_income"] doubleValue];
    income.rechargeBank = [[record1 objectForKey:@"rechargecard_bank"] doubleValue];
    income.rechargeCash = [[record1 objectForKey:@"rechargecard_cash"] doubleValue];
    income.newcardBank = [[record1 objectForKey:@"newcard_bank"] doubleValue];
    income.newcardCash = [[record1 objectForKey:@"newcard_cash"] doubleValue];
    income.totalPrepay = [[record1 objectForKey:@"total_prepay"] doubleValue];
    income.paidinBank = [[record1 objectForKey:@"total_paidin_bank"] doubleValue];
    income.paidinCash = [[record1 objectForKey:@"total_paidin_cash"] doubleValue];
    income.totalPaidin = [[record1 objectForKey:@"total_paidin"] doubleValue];
    income.incomeRatio = income.totalIncome / (income.totalIncome + income.totalPrepay);
    income.prepayRatio = 1 - income.incomeRatio;
    
    double incomePrev;
    double prepayPrev;
    double paidinPrev;
    
    if([record2 objectForKey:@"_id"]){
        incomePrev = [[record2 objectForKey:@"total_income"] doubleValue];
        prepayPrev = [[record2 objectForKey:@"total_prepay"] doubleValue];
        paidinPrev = [[record2 objectForKey:@"total_paidin"] doubleValue];
    }else{
        incomePrev = 0;
        prepayPrev = 0;
        paidinPrev = 0;
    }
    
    CompareResult *incomeCompare = [self assembleCompareWithCurrentValue:income.totalIncome prevValue:incomePrev];
    income.incomeCompareToPrev = incomeCompare.compareToPrev;
    income.incomeCompareToPrevRatio = incomeCompare.compareToPrevRatio;
    income.incomeIncreased = incomeCompare.increased;
    
    CompareResult *prepayCompare = [self assembleCompareWithCurrentValue:income.totalPrepay prevValue:prepayPrev];
    income.prepayCompareToPrev = prepayCompare.compareToPrev;
    income.prepayCompareToPrevRatio = prepayCompare.compareToPrevRatio;
    income.prepayIncreased = prepayCompare.increased;
    
    CompareResult *paidinCompare = [self assembleCompareWithCurrentValue:income.totalPaidin prevValue:paidinPrev];
    income.paidinCompareToPrev = paidinCompare.compareToPrev;
    income.paidinCompareToPrevRatio = paidinCompare.compareToPrevRatio;
    income.paidinIncreased = paidinCompare.increased;
}

-(CompareResult*) assembleCompareWithCurrentValue:(double)current prevValue:(double)previous
{
    CompareResult *result = [[CompareResult alloc] init];
    
    if(current >= previous){
        result.increased = YES;
    }else{
        result.increased = NO;
    }
    
    result.compareToPrev = abs(current - previous);
    
    if(previous != 0){
        result.compareToPrevRatio = result.compareToPrev / previous;
    }else if(current == 0){
        result.compareToPrevRatio = 0;
    }else{
        result.compareToPrevRatio = 1;
    }
    
    return result;
}

#pragma mark - ReportIncomeViewDataSource

-(BOOL) support
{
    return support;
}

-(BOOL) hasData
{
    return (income != nil);
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
        NSString *title = [NSString stringWithFormat:@"收入 %.1f%%", income.incomeRatio * 100];
        return [[LosPieChartItem alloc] initWithTitle:title Ratio:income.incomeRatio];
    }else{
        NSString *title = [NSString stringWithFormat:@"预付款 %.1f%%", income.prepayRatio * 100];
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
