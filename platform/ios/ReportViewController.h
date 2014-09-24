#import <UIKit/UIKit.h>
#import "LosTimePicker.h"
#import "SwitchShopButton.h"
#import "ReportEmployeeDataSource.h"
#import "ReportShopDataSource.h"
#import "ReportServiceDataSource.h"
#import "ReportCustomDataSource.h"
#import "InteractiveView.h"
#import "ReportIncomeDataSource.h"

@interface ReportViewController : UIViewController<LosTimePickerDelegate, SwitchShopButtonDelegate, InteractiveViewDelegate>

@property ReportEmployeeDataSource *employeeDataSource;
@property ReportShopDataSource *shopDataSource;
@property ReportServiceDataSource *serviceDataSource;
@property ReportCustomDataSource *customDataSource;
@property ReportIncomeDataSource *incomeDataSource;

-(void) onSingleTap;

@end
