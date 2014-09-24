#import "ReportIncomeDataSource.h"

@implementation ReportIncomeDataSource

{
    Income *income;
}

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block
{
    income = [[Income alloc] init];
    income.serviceBank = 2222;
    income.serviceCash = 4000;
    income.productBank = 222;
    income.productCash = 33;
    income.card = 2422;
    income.totalIncome = 8899;
    income.rechargeBank = 1000;
    income.rechargeCash = 2000;
    income.newcardBank = 3000;
    income.newcardCash = 4000;
    income.totalPrepay = 10000;
    income.paidinBank = 444;
    income.paidinCash = 10000;
    income.totalPaidin = 10444;
    income.incomeRatio = 0.4;
    income.incomeCompareToPrev = 2000;
    income.incomeCompareToPrevRatio = 0.4;
    income.incomeIncreased = YES;
    income.prepayRatio = 0.6;
    income.prepayCompareToPrev = 3000;
    income.prepayCompareToPrevRatio = 0.5;
    income.prepayIncreased = NO;
    income.paidinCompareToPrev = 1000;
    income.paidinCompareToPrevRatio = 0.1;
    income.paidinIncreased = YES;
        
    block(YES);
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
