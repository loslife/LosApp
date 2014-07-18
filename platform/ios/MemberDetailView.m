#import "MemberDetailView.h"

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
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
    name.text = [NSString stringWithFormat:@"姓名：%@", theMember.name];
    name.textAlignment = NSTextAlignmentLeft;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), 0);
    CGContextStrokePath(ctx);
    
    UILabel *birthday = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 40)];
    birthday.text = [NSString stringWithFormat:@"生日：%@", [StringUtils fromNumber:theMember.birthday format:@"MM-dd"]];
    birthday.textAlignment = NSTextAlignmentLeft;
    
    UILabel *memberNo = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
    if([StringUtils isEmpty:theMember.memberNo]){
        memberNo.text = @"编号：";
    }else{
        memberNo.text = [NSString stringWithFormat:@"编号：%@", theMember.memberNo];
    }
    memberNo.textAlignment = NSTextAlignmentLeft;
    
    UILabel *joinDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
    joinDate.text = [NSString stringWithFormat:@"入会时间：%@", [StringUtils fromNumber:theMember.joinDate format:@"MM-dd"]];
    joinDate.textAlignment = NSTextAlignmentLeft;
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 280, 40)];
    phone.text = [NSString stringWithFormat:@"联系方式：%@", theMember.phoneMobile];
    phone.textAlignment = NSTextAlignmentLeft;
    
    UIButton *call = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    call.frame = CGRectMake(240, 240, 40, 40);
    [call setTitle:@"call" forState:UIControlStateNormal];
    [call addTarget:self action:@selector(callMember) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cards = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 40)];
    cards.text = [NSString stringWithFormat:@"会员卡类型：%@", @"金卡"];
    cards.textAlignment = NSTextAlignmentLeft;
    
    UILabel *latest = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 40)];
    latest.text = [NSString stringWithFormat:@"最后消费时间：%@", [StringUtils fromNumber:theMember.latestConsumeTime format:@"MM-dd"]];
    latest.textAlignment = NSTextAlignmentLeft;
    
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 40)];
    total.text = [NSString stringWithFormat:@"累计消费：￥%.1f", [theMember.totalConsume doubleValue]];
    total.textAlignment = NSTextAlignmentLeft;
    
    UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 280, 40)];
    per.text = [NSString stringWithFormat:@"客单价：￥%.1f", [theMember.averageConsume doubleValue]];
    per.textAlignment = NSTextAlignmentLeft;
    
    UILabel *sex = [[UILabel alloc] initWithFrame:CGRectMake(20, 480, 280, 40)];
    sex.text = [NSString stringWithFormat:@"%d", [theMember.sex intValue]];
    sex.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:name];
    [self addSubview:birthday];
    [self addSubview:memberNo];
    [self addSubview:joinDate];
    [self addSubview:phone];
    [self addSubview:call];
    [self addSubview:cards];
    [self addSubview:latest];
    [self addSubview:total];
    [self addSubview:per];
    [self addSubview:sex];
}

-(void) callMember
{
    NSString *url = [NSString stringWithFormat:@"tel://%@", theMember.phoneMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
