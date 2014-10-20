#import <Foundation/Foundation.h>
#import "LosPieChart.h"
#import "ReportIncomeView.h"

@interface ReportIncomeDataSource : NSObject<ReportIncomeViewDataSource, LosPieChartDelegate>

-(void) loadFromServer:(BOOL)flag block:(void(^)(BOOL))block;

@end
