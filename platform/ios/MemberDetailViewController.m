#import "MemberDetailViewController.h"
#import "MemberDetailView.h"

@implementation MemberDetailViewController

{
    Member *theMember;
}

-(id) initWithMember:(Member*)member
{
    self = [super init];
    if(self){
        
        theMember = member;
        
        self.navigationItem.title = @"会员详情";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void) loadView
{
    MemberDetailView *view = [[MemberDetailView alloc] initWithMember:theMember];
    self.view = view;
}

@end
