#import "MemberDetailView.h"

@interface Line : UIView

@end

@implementation Line

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), 0);
    CGContextStrokePath(ctx);
}

@end

@implementation MemberDetailView

{
    Member *theMember;
}

-(id) initWithMember:(Member*)member
{
    self = [super init];
    if(self){
        
        theMember = member;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
        name.text = [NSString stringWithFormat:@"姓名：%@", member.name];
        name.textAlignment = NSTextAlignmentLeft;
        
        UILabel *birthday = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 40)];
        birthday.text = [NSString stringWithFormat:@"生日：%@", [StringUtils fromNumber:member.birthday]];
        birthday.textAlignment = NSTextAlignmentLeft;
        
        UILabel *memberNo = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, 280, 40)];
        if([StringUtils isEmpty:member.memberNo]){
            memberNo.text = @"编号：";
        }else{
            memberNo.text = [NSString stringWithFormat:@"编号：%@", member.memberNo];
        }
        memberNo.textAlignment = NSTextAlignmentLeft;
        
        UILabel *joinDate = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 280, 40)];
        joinDate.text = [NSString stringWithFormat:@"入会时间：%@", [StringUtils fromNumber:member.joinDate]];
        joinDate.textAlignment = NSTextAlignmentLeft;
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, 280, 40)];
        phone.text = [NSString stringWithFormat:@"联系方式：%@", member.phoneMobile];
        phone.textAlignment = NSTextAlignmentLeft;
        
        UIButton *call = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        call.frame = CGRectMake(240, 240, 40, 40);
        [call setTitle:@"call" forState:UIControlStateNormal];
        [call addTarget:self action:@selector(callMember) forControlEvents:UIControlEventTouchUpInside];
        
        Line *line = [[Line alloc] initWithFrame:CGRectMake(20, 300, 280, 1)];
        
        UILabel *cards = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, 40)];
        cards.text = [NSString stringWithFormat:@"会员卡类型：%@", @"金卡"];
        cards.textAlignment = NSTextAlignmentLeft;
        
        UILabel *frequency = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 280, 40)];
        frequency.text = @"消费频度：5天消费1次";
        frequency.textAlignment = NSTextAlignmentLeft;
        
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 280, 40)];
        total.text = @"累计消费：￥1000.0";
        total.textAlignment = NSTextAlignmentLeft;
        
        UILabel *per = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 280, 40)];
        per.text = @"客单价：￥105.2";
        per.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:name];
        [self addSubview:birthday];
        [self addSubview:memberNo];
        [self addSubview:joinDate];
        [self addSubview:phone];
        [self addSubview:call];
        [self addSubview:line];
        [self addSubview:cards];
        [self addSubview:frequency];
        [self addSubview:total];
        [self addSubview:per];
    }
    return self;
}

-(void) callMember
{
    NSString *url = [NSString stringWithFormat:@"tel://%@", theMember.phoneMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
