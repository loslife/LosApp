#import <UIKit/UIKit.h>
#import "ReportViewController.h"

@interface ReportView : UIView

-(id) initWithController:(ReportViewController*)controller;
-(void) reloadData;
-(void) showLoading;
-(void) showData;

@end
