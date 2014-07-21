#import "ReportView.h"
#import "ReportDateStatus.h"
#import "LosTimePicker.h"
#import "ReportEmployeeView.h"

@implementation ReportView

-(id) initWithController:(ReportViewController*)controller
{
    self = [super init];
    if(self){
        
        ReportDateStatus *status = [ReportDateStatus sharedInstance];
        LosTimePicker *dateSelectionBar = [[LosTimePicker alloc] initWithFrame:CGRectMake(0, 64, 320, 40) Delegate:controller InitDate:[status date] type:[status dateType]];
        
        UIScrollView *dataArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, 320, 415)];
        dataArea.contentSize = CGSizeMake(1280, 415);
        dataArea.pagingEnabled = YES;
        
        ReportEmployeeView *employee = [[ReportEmployeeView alloc] initWithFrame:CGRectMake(0, 0, 320, 415) DataSource:controller.employeeDataSource];
        
        ReportShopView *shop = [[ReportShopView alloc] initWithFrame:CGRectMake(320, 0, 320, 415) DataSource:controller.shopDataSource];
        
        ReportServiceView *service = [[ReportServiceView alloc] initWithFrame:CGRectMake(640, 0, 320, 415) DataSource:controller.serviceDataSource];
        
        ReportCustomView *custom = [[ReportCustomView alloc] initWithFrame:CGRectMake(960, 0, 320, 415) DataSource:controller.customDataSource];
        
        [dataArea addSubview:employee];
        [dataArea addSubview:shop];
        [dataArea addSubview:service];
        [dataArea addSubview:custom];
        
        [self addSubview:dateSelectionBar];
        [self addSubview:dataArea];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(onSingleTap)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tap];
    }
    return self;
}

@end
