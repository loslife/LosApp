#import "ReportShopView.h"

@implementation ReportShopView

-(id) initWithController:(ReportShopViewController*)controller
{
    self = [super initWithController:controller];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 100, 320, 468);
        label.text = @"店铺业绩";
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
    }
    return self;
}

@end
