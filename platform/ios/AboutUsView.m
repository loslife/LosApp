#import "AboutUsView.h"

@implementation AboutUsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITextView *p = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 280, 240)];
        p.text = @"乐斯作为行业领先的美业管理与客户服务平台解决方案供应商，创始人员全部来自于世界500强企业海外、国内的资深经理人与行业专家，在通讯，软件，管理，咨询，服务等方面积累了丰富的成功经验，并致力于把全球范围内的先进行业管理理念与实践带入美业，助力美业的服务转型与升级。\r\n\r\n乐斯专注于为美业企业提供下一代基于SaaS云平台与移动互联网的社会化客户关系管理（Social CRM），移动门户（Mobile Portal）、精准营销(Presicion Marketing)与内部协作(Internal Cooperation)整体解决方案。\r\n\r\n客户是乐斯最重要的资产，为客户提供高水准的服务是我们不懈的追求，客户的满意度是对我们最大的肯定与褒奖。";
        p.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);
        p.delegate = self;
        
        UIView *qq = [self viewWithFrame:CGRectMake(20, 320, 280, 40) Image:@"us_qq" text:@"1994714502"];
        UIView *phone = [self viewWithFrame:CGRectMake(20, 360, 280, 40) Image:@"us_phone" text:@"0755-28890800"];
        UIView *website = [self viewWithFrame:CGRectMake(20, 400, 280, 40) Image:@"us_website" text:@"www.yilos.com"];
        
        [self addSubview:p];
        [self addSubview:qq];
        [self addSubview:phone];
        [self addSubview:website];
    }
    return self;
}

-(UIView*) viewWithFrame:(CGRect)frame Image:(NSString*)imageName text:(NSString*)text
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    image.frame = CGRectMake(10, 10, 20, 20);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 240, 40)];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:12];
    
    [view addSubview:image];
    [view addSubview:label];
    
    return view;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
