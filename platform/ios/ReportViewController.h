#import <UIKit/UIKit.h>
#import "LosTimePicker.h"
#import "SwitchShopButton.h"
#import "ReportEmployeeDataSource.h"
#import "ReportShopDataSource.h"
#import "ReportServiceDataSource.h"
#import "ReportCustomDataSource.h"

@interface ReportViewController : UIViewController<LosTimePickerDelegate, SwitchShopButtonDelegate>

@property ReportEmployeeDataSource *employeeDataSource;
@property ReportShopDataSource *shopDataSource;
@property ReportServiceDataSource *serviceDataSource;
@property ReportCustomDataSource *customDataSource;

-(void) onSingleTap;

@end
