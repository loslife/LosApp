#import "MemberDetailView.h"

@implementation MemberDetailView

-(id) initWithMember:(Member*)member
{
    self = [super init];
    if(self){
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        name.text = member.name;
        name.textAlignment = NSTextAlignmentLeft;
        
        UILabel *birthday = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
        birthday.text = [StringUtils fromNumber:member.birthday];
        birthday.textAlignment = NSTextAlignmentLeft;
        
        UILabel *memberNo = [[UILabel alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
        if([StringUtils isEmpty:member.memberNo]){
            memberNo.text = @"";
        }else{
            memberNo.text = member.memberNo;
        }
        memberNo.textAlignment = NSTextAlignmentLeft;
        
        UILabel *joinDate = [[UILabel alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
        joinDate.text = [StringUtils fromNumber:member.joinDate];
        joinDate.textAlignment = NSTextAlignmentLeft;
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
        phone.text = member.phoneMoble;
        phone.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:name];
        [self addSubview:birthday];
        [self addSubview:memberNo];
        [self addSubview:joinDate];
        [self addSubview:phone];
    }
    return self;
}

@end
