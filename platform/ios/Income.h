#import <Foundation/Foundation.h>

@interface Income : NSObject

@property double serviceBank;// 刷卡服务
@property double serviceCash;// 现金服务
@property double productBank;// 刷卡卖品
@property double productCash;// 现金卖品
@property double card;// 划卡消费
@property double totalIncome;// 收入总计

@property double rechargeBank;// 刷卡充值
@property double rechargeCash;// 现金充值
@property double newcardBank;// 刷卡开卡
@property double newcardCash;// 现金开卡
@property double totalPrepay;// 预付款总计

@property double paidinBank;// 银行卡实收
@property double paidinCash;// 现金实收
@property double totalPaidin;// 实收总计

@property double incomeRatio;// 收入占比
@property double incomeCompareToPrev;// 收入比上月
@property double incomeCompareToPrevRatio;// 收入比上月比例
@property BOOL incomeIncreased;// 收入是增加还是减少

@property double prepayRatio;// 预付款占比
@property double prepayCompareToPrev;// 预付款比上月
@property double prepayCompareToPrevRatio;// 预付款比上月比例
@property BOOL prepayIncreased;// 预付款是增加还是减少

@property double paidinCompareToPrev;// 实收比上月
@property double paidinCompareToPrevRatio;// 实收比上月比例
@property BOOL paidinIncreased;// 实收是增加还是减少

@end
