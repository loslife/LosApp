#import "MemberDetailView.h"
#import "LosStyles.h"

@implementation MemberDetailView

{
    Member *theMember;
}

-(id) initWithMember:(Member*)member
{
    self = [super init];
    if(self){
        
        theMember = member;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;// 568 in 4-inch，480 in 3.5-inch
    CGFloat heightForLabel = (screenHeight - 174) / 9;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(20, 64, 280, 50)];
    
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 17, 16, 16)];
    photo.image = [UIImage imageNamed:@"member_name"];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 50)];
    name.text = theMember.name;
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = BLUE1;
    
    UIImageView *sex = [[UIImageView alloc] initWithFrame:CGRectMake(264, 17, 16, 16)];
    if([theMember.sex intValue] == 0){
        sex.image = [UIImage imageNamed:@"member_female"];
    }else{
        sex.image = [UIImage imageNamed:@"member_male"];
    }
    
    [header addSubview:photo];
    [header addSubview:name];
    [header addSubview:sex];
    
    UIView *birthdayArea = [self makeBaseinfoView:CGRectMake(20, 114, 280, heightForLabel) icon:@"member_birthday" text:[NSString stringWithFormat:@"生日：%@", [StringUtils fromNumber:theMember.birthday format:@"MM-dd"]]];
    
    UIView *noArea = [self makeBaseinfoView:CGRectMake(20, 114 + heightForLabel, 280, heightForLabel) icon:@"member_no" text:[NSString stringWithFormat:@"编号：%@", theMember.memberNo]];
   
    NSNumber *join = [NSNumber numberWithDouble:[theMember.joinDate doubleValue] / 1000];
    UIView *joinArea = [self makeBaseinfoView:CGRectMake(20, 114 + heightForLabel * 2, 280, heightForLabel) icon:@"member_join" text:[NSString stringWithFormat:@"入会时间：%@", [StringUtils fromNumber:join format:@"yyyy-MM-dd"]]];
    
    UIView *contactArea = [self makeBaseinfoView:CGRectMake(20, 114 + heightForLabel * 3, 280, heightForLabel) icon:@"member_contact" text:[NSString stringWithFormat:@"联系方式：%@", theMember.phoneMobile]];
    
    UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 114 + heightForLabel * 4, 320, 5)];
    bar.backgroundColor = GRAY1;
    
    UILabel *consumeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 119 + heightForLabel * 4, 280, heightForLabel)];
    consumeTitle.text = @"消费信息";
    consumeTitle.textAlignment = NSTextAlignmentLeft;
    consumeTitle.font = [UIFont systemFontOfSize:16];
    
    UILabel *cards = [self makeConsumeinfoView:CGRectMake(20, 119 + heightForLabel * 5, 280, heightForLabel) text:[NSString stringWithFormat:@"会员卡：%@", theMember.cardStr]];
    
    UILabel *latest = [self makeConsumeinfoView:CGRectMake(20, 119 + heightForLabel * 6, 280, heightForLabel) text:[NSString stringWithFormat:@"最后消费时间：%@", [StringUtils fromNumber:theMember.latestConsumeTime format:@"MM-dd"]]];

    UILabel *total = [self makeConsumeinfoView:CGRectMake(20, 119 + heightForLabel * 7, 280, heightForLabel) text:[NSString stringWithFormat:@"累计消费：￥%.1f", [theMember.totalConsume doubleValue]]];

    UILabel *per = [self makeConsumeinfoView:CGRectMake(20, 119 + heightForLabel * 8, 280, heightForLabel) text:[NSString stringWithFormat:@"客单价：￥%.1f", [theMember.averageConsume doubleValue]]];
    
    UILabel *bar2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 119 + heightForLabel * 9, 320, 5)];
    bar2.backgroundColor = GRAY1;
    
    UIView *call = [[UIView alloc] initWithFrame:CGRectMake(0, 124 + heightForLabel * 9, 160, 50)];
    
    UIImageView *callIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17, 16, 16)];
    callIcon.image = [UIImage imageNamed:@"member_call"];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callButton.frame = CGRectMake(60, 0, 100, 50);
    [callButton setTitle:@"给ta电话" forState:UIControlStateNormal];
    [callButton setTintColor:BLUE1];
    callButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [callButton addTarget:self action:@selector(callMember) forControlEvents:UIControlEventTouchUpInside];
    
    [call addSubview:callIcon];
    [call addSubview:callButton];
    
    UIView *sms = [[UIView alloc] initWithFrame:CGRectMake(160, 124 + heightForLabel * 9, 160, 50)];
    
    UIImageView *smsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17, 16, 16)];
    smsIcon.image = [UIImage imageNamed:@"member_sms"];
    
    UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    smsButton.frame = CGRectMake(60, 0, 100, 50);
    [smsButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [smsButton setTintColor:BLUE1];
    smsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [smsButton addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    
    [sms addSubview:smsIcon];
    [sms addSubview:smsButton];
    
    [self addSubview:header];
    [self addSubview:birthdayArea];
    [self addSubview:noArea];
    [self addSubview:joinArea];
    [self addSubview:contactArea];
    [self addSubview:bar];
    [self addSubview:consumeTitle];
    [self addSubview:cards];
    [self addSubview:latest];
    [self addSubview:total];
    [self addSubview:per];
    [self addSubview:bar2];
    [self addSubview:call];
    [self addSubview:sms];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, .1f);
    
    CGContextMoveToPoint(ctx, 20, 110);
    CGContextAddLineToPoint(ctx, 300, 110);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 160, screenHeight - 48);
    CGContextAddLineToPoint(ctx, 160, screenHeight - 2);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 1.f);
    CGContextSetStrokeColorWithColor(ctx, GRAY2.CGColor);
    
    CGContextMoveToPoint(ctx, 0, 114 + heightForLabel * 4);
    CGContextAddLineToPoint(ctx, 320, 114 + heightForLabel * 4);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 119 + heightForLabel * 4);
    CGContextAddLineToPoint(ctx, 320, 119 + heightForLabel * 4);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 119 + heightForLabel * 9);
    CGContextAddLineToPoint(ctx, 320, 119 + heightForLabel * 9);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 124 + heightForLabel * 9);
    CGContextAddLineToPoint(ctx, 320, 124 + heightForLabel * 9);
    CGContextStrokePath(ctx);
}

-(void) callMember
{
    NSString *url = [NSString stringWithFormat:@"tel://%@", theMember.phoneMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void) sendSMS
{
    
}

-(UIView*) makeBaseinfoView:(CGRect)frame icon:(NSString*)image text:(NSString*)text
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 16) / 2, 16, 16)];
    icon.image = [UIImage imageNamed:image];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 250, frame.size.height)];
    message.text = text;
    message.textAlignment = NSTextAlignmentLeft;
    message.textColor = GRAY4;
    message.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:icon];
    [view addSubview:message];
    
    return view;
}

-(UILabel*) makeConsumeinfoView:(CGRect)frame text:(NSString*)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = GRAY4;
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

@end
