#import <UIKit/UIKit.h>
#import "ReportViewController.h"

@interface ReportView : UIView

-(id) initWithController:(ReportViewController*)controller;
-(void) reloadAndShowData;
-(void) showLoading;

@end
