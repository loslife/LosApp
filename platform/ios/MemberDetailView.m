#import "MemberDetailView.h"

@implementation MemberDetailView

-(id) initWithMember:(Member*)member
{
    self = [super init];
    if(self){
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        name.text = member.name;
        name.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:name];
    }
    return self;
}

@end
