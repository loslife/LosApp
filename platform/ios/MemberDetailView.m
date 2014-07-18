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
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 280, 50)];
    
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
    
    UIView *birthdayArea = [self makeBaseinfoView:CGRectMake(20, 110, 280, 40) icon:@"member_birthday" text:[NSString stringWithFormat:@"生日：%@", [StringUtils fromNumber:theMember.birthday format:@"MM-dd"]]];
    
    UIView *noArea = [self makeBaseinfoView:CGRectMake(20, 150, 280, 40) icon:@"member_no" text:[NSString stringWithFormat:@"编号：%@", theMember.memberNo]];
    
    UIView *joinArea = [self makeBaseinfoView:CGRectMake(20, 190, 280, 40) icon:@"member_join" text:[NSString stringWithFormat:@"入会时间：%@", [StringUtils fromNumber:theMember.joinDate format:@"yyyy-MM-dd"]]];
    
    UIView *contactArea = [self makeBaseinfoView:CGRectMake(20, 230, 280, 40) icon:@"member_contact" text:[NSString stringWithFormat:@"联系方式：%@", theMember.phoneMobile]];
    
    UILabel *bar = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, 320, 5)];
    bar.backgroundColor = GRAY1;
    
    UILabel *consumeTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 40)];
    consumeTitle.text = @"消费信息";
    consumeTitle.textAlignment = NSTextAlignmentLeft;
    consumeTitle.font = [UIFont systemFontOfSize:16];
    
    UILabel *cards = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 40)];
    cards.text = [NSString stringWithFormat:@"会员卡：%@", theMember.cardStr];
    cards.textAlignment = NSTextAlignmentLeft;
    cards.textColor = GRAY4;
    cards.font = [UIFont systemFontOfSize:14];

    UILabel *latest = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 40)];
    latest.text = [NSString stringWithFormat:@"最后消费时间：%@", [StringUtils fromNumber:theMember.latestConsumeTime format:@"MM-dd"]];
    latest.textAlignment = NSTextAlignmentLeft;
    latest.textColor = GRAY4;
    latest.font = [UIFont systemFontOfSize:14];

    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 40)];
    total.text = [NSString stringWithFormat:@"累计消费：￥%.1f", [theMember.totalConsume doubleValue]];
    total.textAlignment = NSTextAlignmentLeft;
    total.textColor = GRAY4;
    total.font = [UIFont systemFontOfSize:14];

    UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 280, 40)];
    per.text = [NSString stringWithFormat:@"客单价：￥%.1f", [theMember.averageConsume doubleValue]];
    per.textAlignment = NSTextAlignmentLeft;
    per.textColor = GRAY4;
    per.font = [UIFont systemFontOfSize:14];
    
    UILabel *bar2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 513, 320, 5)];
    bar2.backgroundColor = GRAY1;
    
    UIView *call = [[UIView alloc] initWithFrame:CGRectMake(0, 518, 160, 50)];
    
    UIImageView *callIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17, 16, 16)];
    callIcon.image = [UIImage imageNamed:@"member_call"];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callButton.frame = CGRectMake(60, 0, 70, 50);
    [callButton setTitle:@"给ta电话" forState:UIControlStateNormal];
    [callButton setTintColor:BLUE1];
    [callButton addTarget:self action:@selector(callMember) forControlEvents:UIControlEventTouchUpInside];
    
    [call addSubview:callIcon];
    [call addSubview:callButton];
    
    UIView *sms = [[UIView alloc] initWithFrame:CGRectMake(160, 518, 160, 50)];
    
    UIImageView *smsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17, 16, 16)];
    smsIcon.image = [UIImage imageNamed:@"member_sms"];
    
    UIButton *smsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    smsButton.frame = CGRectMake(60, 0, 70, 50);
    [smsButton setTitle:@"发送短信" forState:UIControlStateNormal];
    [smsButton setTintColor:BLUE1];
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
    
    CGContextMoveToPoint(ctx, 160, 520);
    CGContextAddLineToPoint(ctx, 160, 566);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 1.f);
    CGContextSetStrokeColorWithColor(ctx, GRAY2.CGColor);
    
    CGContextMoveToPoint(ctx, 0, 270);
    CGContextAddLineToPoint(ctx, 320, 270);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 275);
    CGContextAddLineToPoint(ctx, 320, 275);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 513);
    CGContextAddLineToPoint(ctx, 320, 513);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, 0, 518);
    CGContextAddLineToPoint(ctx, 320, 518);
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
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 16, 16)];
    icon.image = [UIImage imageNamed:image];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 250, 40)];
    message.text = text;
    message.textAlignment = NSTextAlignmentLeft;
    message.textColor = GRAY4;
    message.font = [UIFont systemFontOfSize:14];
    
    [view addSubview:icon];
    [view addSubview:message];
    
    return view;
}

@end
