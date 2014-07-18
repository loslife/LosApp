#import "AboutUsView.h"
#import "LosStyles.h"

@implementation AboutUsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = GRAY1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 280, 320)];
        label.text = @"       乐斯作为行业领先的美业管理与客户服务平台解决方案供应商，创始人员全部来自于世界500强企业海外、国内的资深经理人与行业专家，在通讯，软件，管理，咨询，服务等方面积累了丰富的成功经验，并致力于把全球范围内的先进行业管理理念与实践带入美业，助力美业的服务转型与升级。\r\n\r\n       乐斯专注于为美业企业提供下一代基于SaaS云平台与移动互联网的社会化客户关系管理（Social CRM），移动门户（Mobile Portal），精准营销(Presicion Marketing)与内部协作(Internal Cooperation)整体解决方案。\r\n\r\n       客户是乐斯最重要的资产，为客户提供高水准的服务是我们不懈的追求，客户的满意度是对我们最大的肯定与褒奖。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = GRAY4;
        label.numberOfLines = 20;
        
        UIView *contactArea = [[UIView alloc] initWithFrame:CGRectMake(0, 390, 320, 130)];
        contactArea.backgroundColor = [UIColor whiteColor];
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        message.text = @"如果您有任何建议或疑问，请联系我们";
        message.textAlignment = NSTextAlignmentLeft;
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = GRAY4;
        
        UIView *qq = [self viewWithFrame:CGRectMake(20, 40, 280, 30) Image:@"us_qq" text:@"QQ：1994714502"];
        UIView *website = [self viewWithFrame:CGRectMake(20, 70, 280, 30) Image:@"us_website" text:@"邮箱：service@yilos.com"];
        UIView *phone = [self viewWithFrame:CGRectMake(20, 100, 280, 30) Image:@"us_phone" text:@"电话：0755-28890800"];
        
        [contactArea addSubview:message];
        [contactArea addSubview:qq];
        [contactArea addSubview:website];
        [contactArea addSubview:phone];
        
        [self addSubview:label];
        [self addSubview:contactArea];
    }
    return self;
}

-(UIView*) viewWithFrame:(CGRect)frame Image:(NSString*)imageName text:(NSString*)text
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    image.frame = CGRectMake(0, 10, 10, 10);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 260, 30)];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = BLUE1;
    
    [view addSubview:image];
    [view addSubview:label];
    
    return view;
}

@end
