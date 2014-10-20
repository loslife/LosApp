#import "ReportViewBase.h"
#import "LosPieChart.h"
#import "Income.h"

@protocol ReportIncomeViewDataSource <NSObject>

-(BOOL) hasData;
-(Income*) domainModel;

@end

@interface ReportIncomeView : ReportViewBase

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportIncomeViewDataSource, LosPieChartDelegate>)ds;

@end
