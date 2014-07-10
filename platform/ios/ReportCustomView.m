#import "ReportCustomView.h"
#import "ReportCustomViewController.h"

@implementation ReportCustomView

-(id) initWithController:(id<ReportCustomerViewDataSource>)controller
{
    self = [super initWithController:(ReportViewControllerBase*)controller];
    if(self){
        
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 40);
        label.text = @"客流量";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    UILabel *x_label1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 140, 40, 40)];
    [x_label1 setTextAlignment:NSTextAlignmentCenter];
    [x_label1 setTextColor:[UIColor redColor]];
    [x_label1 setText:@"0"];
    [self addSubview:x_label1];
    
    UILabel *x_label2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 140, 40, 40)];
    [x_label2 setTextAlignment:NSTextAlignmentCenter];
    [x_label2 setTextColor:[UIColor redColor]];
    [x_label2 setText:@"10"];
    [self addSubview:x_label2];
    
    UILabel *x_label3 = [[UILabel alloc]initWithFrame:CGRectMake(180, 140, 40, 40)];
    [x_label3 setTextAlignment:NSTextAlignmentCenter];
    [x_label3 setTextColor:[UIColor redColor]];
    [x_label3 setText:@"20"];
    [self addSubview:x_label3];
    
    UILabel *x_label4 = [[UILabel alloc]initWithFrame:CGRectMake(220, 140, 40, 40)];
    [x_label4 setTextAlignment:NSTextAlignmentCenter];
    [x_label4 setTextColor:[UIColor redColor]];
    [x_label4 setText:@"30"];
    [self addSubview:x_label4];
    
    UILabel *y_label1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 180, 40, 40)];
    [y_label1 setTextAlignment:NSTextAlignmentCenter];
    [y_label1 setTextColor:[UIColor blueColor]];
    [y_label1 setText:@"1"];
    [self addSubview:y_label1];
    
    UILabel *y_label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 220, 40, 40)];
    [y_label2 setTextAlignment:NSTextAlignmentCenter];
    [y_label2 setTextColor:[UIColor blueColor]];
    [y_label2 setText:@"2"];
    [self addSubview:y_label2];
    
    UILabel *y_label3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 260, 40, 40)];
    [y_label3 setTextAlignment:NSTextAlignmentCenter];
    [y_label3 setTextColor:[UIColor blueColor]];
    [y_label3 setText:@"3"];
    [self addSubview:y_label3];
    
    UILabel *y_label4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 300, 40, 40)];
    [y_label4 setTextAlignment:NSTextAlignmentCenter];
    [y_label4 setTextColor:[UIColor blueColor]];
    [y_label4 setText:@"4"];
    [self addSubview:y_label4];
    
    UILabel *y_label5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 340, 40, 40)];
    [y_label5 setTextAlignment:NSTextAlignmentCenter];
    [y_label5 setTextColor:[UIColor blueColor]];
    [y_label5 setText:@"5"];
    [self addSubview:y_label5];
    
    UILabel *y_label6 = [[UILabel alloc]initWithFrame:CGRectMake(60, 380, 40, 40)];
    [y_label6 setTextAlignment:NSTextAlignmentCenter];
    [y_label6 setTextColor:[UIColor blueColor]];
    [y_label6 setText:@"6"];
    [self addSubview:y_label6];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
	CGContextMoveToPoint(context, 120, 200);
    
    CGContextAddLineToPoint(context, 150, 240);
    UILabel *point1 = [[UILabel alloc] init];
    point1.frame = CGRectMake(0, 0, 10, 10);
    point1.center = CGPointMake(150, 240);
    point1.backgroundColor = [UIColor greenColor];
    [self addSubview:point1];
    
    CGContextAddLineToPoint(context, 200, 280);
    UILabel *point2 = [[UILabel alloc] init];
    point2.frame = CGRectMake(0, 0, 10, 10);
    point2.center = CGPointMake(200, 280);
    point2.backgroundColor = [UIColor greenColor];
    [self addSubview:point2];
    
    CGContextAddLineToPoint(context, 220, 320);
    UILabel *point3 = [[UILabel alloc] init];
    point3.frame = CGRectMake(0, 0, 10, 10);
    point3.center = CGPointMake(220, 320);
    point3.backgroundColor = [UIColor greenColor];
    [self addSubview:point3];
    
    CGContextAddLineToPoint(context, 200, 360);
    UILabel *point4 = [[UILabel alloc] init];
    point4.frame = CGRectMake(0, 0, 10, 10);
    point4.center = CGPointMake(200, 360);
    point4.backgroundColor = [UIColor greenColor];
    [self addSubview:point4];
    
    CGContextAddLineToPoint(context, 240, 400);
    UILabel *point5 = [[UILabel alloc] init];
    point5.frame = CGRectMake(0, 0, 10, 10);
    point5.center = CGPointMake(240, 400);
    point5.backgroundColor = [UIColor greenColor];
    [self addSubview:point5];
    
    CGContextStrokePath(context);
}

@end
