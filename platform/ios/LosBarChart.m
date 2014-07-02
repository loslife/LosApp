#import "LosBarChart.h"

@implementation LosBarChart

{
    id<LosBarChartDataSource> delegate;
    UILabel *total;
    UIView *mainArea;
}

-(id) initWithFrame:(CGRect)frame DataSource:(id<LosBarChartDataSource>)ds
{
    self = [super initWithFrame:frame];
    if(self){
        
        delegate = ds;

        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"员工业绩";
        label.textAlignment = NSTextAlignmentLeft;
        
        total = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 100, 40)];
        total.textAlignment = NSTextAlignmentLeft;
        
        [header addSubview:label];
        [header addSubview:total];
        
        mainArea = [[UIView alloc] initWithFrame:CGRectMake(0, 140, 320, 428)];
        
        [self addSubview:header];
        [self addSubview:mainArea];
    }
    return self;
}

-(void) reload
{
    total.text = [NSString stringWithFormat:@"￥%d", [delegate totalValue]];
    
    for(UIView *sub in mainArea.subviews){
        [sub removeFromSuperview];
    }
    
    NSUInteger count = [delegate rowCount];
    if(count == 0){
        return;
    }
    
    int maxValue = [delegate maxValue];
    CGFloat lengthPerValue = 120 / maxValue;

    for(int i = 0; i< count; i++){
        
        UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        name.text = [delegate nameAtIndex:i];
        name.textAlignment = NSTextAlignmentLeft;
        
        CGFloat barLength = [delegate valueAtIndex:i] * lengthPerValue;
        UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, barLength, 10)];
        bar.backgroundColor = [UIColor redColor];
        
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(80 + barLength, 0, 60, 40)];
        money.text = [NSString stringWithFormat:@"￥%d", [delegate valueAtIndex:i]];
        money.textAlignment = NSTextAlignmentLeft;
        
        [row addSubview:name];
        [row addSubview:bar];
        [row addSubview:money];
        
        [mainArea addSubview:row];
    }
}

@end
