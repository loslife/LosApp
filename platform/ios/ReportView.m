#import "ReportView.h"
#import "ReportDateStatus.h"
#import "LosTimePicker.h"
#import "LosStyles.h"

@implementation ReportView

{
    ReportViewController *myController;
    
    UIView *loading;
    UIScrollView *dataArea;
}

-(id) initWithController:(ReportViewController*)controller
{
    self = [super init];
    if(self){
        
        myController = controller;
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 64, 320, 40) Delegate:controller InitDate:[status date] type:[status dateType]];
        [self addSubview:dateSelectionBar];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(onSingleTap)];
        [self addGestureRecognizer:tap];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
        CGFloat contentHeight = screenHeight - 153;
        
        loading = [[UIView alloc] initWithFrame:CGRectMake(0, 104, 320, contentHeight)];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(160, contentHeight / 2 - 30)];
        [indicator startAnimating];
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        message.center = CGPointMake(160, contentHeight / 2);
        message.text = @"正在加载报表数据，请稍候";
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = GRAY4;
        
        [loading addSubview:indicator];
        [loading addSubview:message];
        
        dataArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, 320, contentHeight)];
        dataArea.contentSize = CGSizeMake(1600, contentHeight);
        dataArea.pagingEnabled = YES;
        dataArea.showsHorizontalScrollIndicator = NO;
        
        ReportIncomeView *income = [[ReportIncomeView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight) DataSource:controller.incomeDataSource];
        
        ReportShopView *shop = [[ReportShopView alloc] initWithFrame:CGRectMake(320, 0, 320, contentHeight) DataSource:controller.shopDataSource];
        
        ReportEmployeeView *employee = [[ReportEmployeeView alloc] initWithFrame:CGRectMake(640, 0, 320, contentHeight) DataSource:controller.employeeDataSource];
        
        ReportServiceView *service = [[ReportServiceView alloc] initWithFrame:CGRectMake(960, 0, 320, contentHeight) DataSource:controller.serviceDataSource];
        
        ReportCustomView *custom = [[ReportCustomView alloc] initWithFrame:CGRectMake(1280, 0, 320, contentHeight) DataSource:controller.customDataSource];
        
        [dataArea addSubview:income];
        [dataArea addSubview:shop];
        [dataArea addSubview:employee];
        [dataArea addSubview:service];
        [dataArea addSubview:custom];
    }
    return self;
}

-(void) reloadAndShowData
{
    [loading removeFromSuperview];
    
    for(UIView *subview in dataArea.subviews){
        
        if([subview isKindOfClass:[ReportViewBase class]]){
            [(ReportViewBase*)subview reload];
        }        
    }
    
    [self addSubview:dataArea];
}

-(void) showLoading
{
    [dataArea removeFromSuperview];
    [self addSubview:loading];
}

@end
