#import <UIKit/UIKit.h>
#import "ReportViewBase.h"
#import "ReportEmployeeViewController.h"
#import "LosBarChart.h"

@interface ReportEmployeeView : ReportViewBase

@property LosBarChart *barView;

-(id) initWithController:(ReportEmployeeViewController*)controller;

@end
