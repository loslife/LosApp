#import "AppUpdateViewController.h"

@interface LosVersionInfo : NSObject

@property BOOL flag;
@property NSString *code;
@property NSArray *featureDescriptions;

-(id) initWithFlag:(BOOL)flag code:(NSString*)code descs:(NSArray*)descs;

@end

@implementation LosVersionInfo

-(id) initWithFlag:(BOOL)flag code:(NSString*)code descs:(NSArray*)descs
{
    self = [super init];
    if(self){
        self.flag = flag;
        self.code = code;
        self.featureDescriptions = descs;
    }
    return self;
}

@end

@implementation AppUpdateViewController

{
    LosVersionInfo *info;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        info = nil;
        
        self.navigationItem.title = @"版本更新";
    }
    return self;
}

-(void) loadView
{
    AppUpdateView *view = [[AppUpdateView alloc] initWithController:self];
    self.view = view;
}

-(void) viewDidAppear:(BOOL)animated
{
    info = [[LosVersionInfo alloc] initWithFlag:YES code:@"1.2.0" descs:@[@"hehe", @"haha", @"xixi"]];
    
    AppUpdateView* myView = (AppUpdateView*)self.view;
    [myView reload];
}

#pragma mark - delegate

-(void) update
{
    NSLog(@"hehe");
}

-(BOOL) hasNewVersion
{
    return info.flag;
}

-(NSString*) newVersionCode
{
    return info.code;
}

-(NSArray*) featuresDescription
{
    return info.featureDescriptions;
}

@end
