#import "ReportIncomeView.h"
#import "LosStyles.h"
#import "PerformanceCompareView.h"
#import "Income.h"

@implementation ReportIncomeView

{
    id<ReportIncomeViewDataSource, LosPieChartDelegate> dataSource;
    UIScrollView *main;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<ReportIncomeViewDataSource, LosPieChartDelegate>)ds
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        dataSource = ds;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *header = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        header.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"经营收入";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:32/255.0f green:37/255.0f blue:41/255.0f alpha:1.0f];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(80, 11, 20, 18);
        self.button.tintColor = BLUE1;
        [self.button setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(refreshButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [header addSubview:label];
        [header addSubview:self.button];
        
        [self addSubview:header];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, .1f);
    CGContextMoveToPoint(ctx, 20, 39.5);
    CGContextAddLineToPoint(ctx, 300, 39.5);
    CGContextStrokePath(ctx);
    
    [main removeFromSuperview];
    
    if([dataSource hasData]){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        CGFloat mainHeight = screenHeight - 193;
        
        CGFloat pieHeight = round(mainHeight * 0.4);
        CGFloat barHeight = 10;
        CGFloat footerHeight = 300;
        
        main = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, mainHeight)];
        main.contentSize = CGSizeMake(320, pieHeight + barHeight + footerHeight);
        
        LosPieChart *pie = [[LosPieChart alloc] initWithFrame:CGRectMake(0, 0, 320, pieHeight) Delegate:dataSource];
        
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, pieHeight, 320, barHeight)];
        bar.backgroundColor = GRAY1;
        bar.layer.borderColor = GRAY2.CGColor;
        bar.layer.borderWidth = .5f;
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, pieHeight + 10, 320, footerHeight)];
        
        Income *model = [dataSource domainModel];
        
        PerformanceCompareView *c1 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 10, 320, 40) Title:@"收入" Compare:model.incomeCompareToPrev CompareRatio:model.incomeCompareToPrevRatio Value:model.totalIncome Increase:model.incomeIncreased];
        
        UILabel *line = [[UILabel alloc] init];
        line.frame = CGRectMake(20, 50, 280, .5);
        line.backgroundColor = [UIColor grayColor];
        
        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 50, 120, 20)];
        l1.text = @"服务现金/银行卡";
        l1.font = [UIFont systemFontOfSize:14.0];
        l1.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 140, 20)];
        l2.text = [NSString stringWithFormat:@"￥%.1f/￥%.1f", model.serviceCash, model.serviceBank];
        l2.font = [UIFont systemFontOfSize:14.0];
        l2.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l2.textAlignment = NSTextAlignmentRight;
        
        UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 120, 20)];
        l3.text = @"卖品现金/银行卡";
        l3.font = [UIFont systemFontOfSize:14.0];
        l3.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l4 = [[UILabel alloc] initWithFrame:CGRectMake(160, 70, 140, 20)];
        l4.text = [NSString stringWithFormat:@"￥%.1f/￥%.1f", model.productCash, model.productBank];
        l4.font = [UIFont systemFontOfSize:14.0];
        l4.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l4.textAlignment = NSTextAlignmentRight;
        
        UILabel *l5 = [[UILabel alloc] initWithFrame:CGRectMake(40, 90, 120, 20)];
        l5.text = @"划卡消费";
        l5.font = [UIFont systemFontOfSize:14.0];
        l5.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l6 = [[UILabel alloc] initWithFrame:CGRectMake(160, 90, 140, 20)];
        l6.text = [NSString stringWithFormat:@"￥%.1f", model.card];
        l6.font = [UIFont systemFontOfSize:14.0];
        l6.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l6.textAlignment = NSTextAlignmentRight;
        
        PerformanceCompareView *c2 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 120, 320, 40) Title:@"预付款" Compare:model.prepayCompareToPrev CompareRatio:model.prepayCompareToPrevRatio Value:model.totalPrepay Increase:model.prepayIncreased];
        
        UILabel *line2 = [[UILabel alloc] init];
        line2.frame = CGRectMake(20, 160, 280, .5);
        line2.backgroundColor = [UIColor grayColor];
        
        UILabel *l7 = [[UILabel alloc] initWithFrame:CGRectMake(40, 160, 120, 20)];
        l7.text = @"开卡现金/银行卡";
        l7.font = [UIFont systemFontOfSize:14.0];
        l7.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l8 = [[UILabel alloc] initWithFrame:CGRectMake(160, 160, 140, 20)];
        l8.text = [NSString stringWithFormat:@"￥%.1f/￥%.1f", model.newcardCash, model.newcardBank];
        l8.font = [UIFont systemFontOfSize:14.0];
        l8.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l8.textAlignment = NSTextAlignmentRight;
        
        UILabel *l9 = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 120, 20)];
        l9.text = @"充值现金/银行卡";
        l9.font = [UIFont systemFontOfSize:14.0];
        l9.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l10 = [[UILabel alloc] initWithFrame:CGRectMake(160, 180, 140, 20)];
        l10.text = [NSString stringWithFormat:@"￥%.1f/￥%.1f", model.rechargeCash, model.rechargeBank];
        l10.font = [UIFont systemFontOfSize:14.0];
        l10.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l10.textAlignment = NSTextAlignmentRight;
        
        PerformanceCompareView *c3 = [[PerformanceCompareView alloc] initWithFrame:CGRectMake(0, 210, 320, 40) Title:@"实收" Compare:model.paidinCompareToPrev CompareRatio:model.paidinCompareToPrevRatio Value:model.totalPaidin Increase:model.paidinIncreased];
        
        UILabel *line3 = [[UILabel alloc] init];
        line3.frame = CGRectMake(20, 250, 280, .5);
        line3.backgroundColor = [UIColor grayColor];
        
        UILabel *l11 = [[UILabel alloc] initWithFrame:CGRectMake(40, 250, 120, 20)];
        l11.text = @"现金";
        l11.font = [UIFont systemFontOfSize:14.0];
        l11.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l12 = [[UILabel alloc] initWithFrame:CGRectMake(160, 250, 140, 20)];
        l12.text = [NSString stringWithFormat:@"￥%.1f", model.paidinCash];
        l12.font = [UIFont systemFontOfSize:14.0];
        l12.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l12.textAlignment = NSTextAlignmentRight;
        
        UILabel *l13 = [[UILabel alloc] initWithFrame:CGRectMake(40, 270, 120, 20)];
        l13.text = @"银行卡";
        l13.font = [UIFont systemFontOfSize:14.0];
        l13.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        
        UILabel *l14 = [[UILabel alloc] initWithFrame:CGRectMake(160, 270, 140, 20)];
        l14.text = [NSString stringWithFormat:@"￥%.1f", model.paidinBank];
        l14.font = [UIFont systemFontOfSize:14.0];
        l14.textColor = [UIColor colorWithRed:114/255.0f green:128/255.0f blue:137/255.0f alpha:1.0f];
        l14.textAlignment = NSTextAlignmentRight;
        
        [footer addSubview:c1];
        [footer addSubview:line];
        [footer addSubview:l1];
        [footer addSubview:l2];
        [footer addSubview:l3];
        [footer addSubview:l4];
        [footer addSubview:l5];
        [footer addSubview:l6];
        [footer addSubview:c2];
        [footer addSubview:line2];
        [footer addSubview:l7];
        [footer addSubview:l8];
        [footer addSubview:l9];
        [footer addSubview:l10];
        [footer addSubview:c3];
        [footer addSubview:line3];
        [footer addSubview:l11];
        [footer addSubview:l12];
        [footer addSubview:l13];
        [footer addSubview:l14];
        
        [main addSubview:pie];
        [main addSubview:bar];
        [main addSubview:footer];
        
        [self addSubview:main];
    }
}

@end
