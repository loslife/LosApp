#import "AppUpdateViewController.h"
#import "LosAppUrls.h"
#import "LosHttpHelper.h"

@interface LosVersionInfo : NSObject

@property BOOL done;
@property BOOL flag;
@property NSString *code;
@property NSArray *featureDescriptions;

-(id) initWithState:(BOOL)done flag:(BOOL)flag code:(NSString*)code descs:(NSArray*)descs;

@end

@implementation LosVersionInfo

-(id) initWithState:(BOOL)done flag:(BOOL)flag code:(NSString*)code descs:(NSArray*)descs
{
    self = [super init];
    if(self){
        self.done = done;
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
    LosHttpHelper *httpHelper;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        info = nil;
        httpHelper = [[LosHttpHelper alloc] init];
        
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            info = [[LosVersionInfo alloc] initWithState:NO flag:NO code:@"" descs:@[]];
            dispatch_async(dispatch_get_main_queue(), ^{
                AppUpdateView* myView = (AppUpdateView*)self.view;
                [myView reload];
            });
            return;
        }
        
        NSString *url = [NSString stringWithFormat:CHECK_NEW_VERSION, @"1"];
        
        [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
            
            if(dict == nil){
                info = [[LosVersionInfo alloc] initWithState:YES flag:NO code:@"" descs:@[]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    AppUpdateView* myView = (AppUpdateView*)self.view;
                    [myView reload];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                info = [[LosVersionInfo alloc] initWithState:YES flag:NO code:@"" descs:@[]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    AppUpdateView* myView = (AppUpdateView*)self.view;
                    [myView reload];
                });
                return;
            }
            
            NSDictionary *result = [dict objectForKey:@"result"];
            
            NSString *flag = [result objectForKey:@"has_new_version"];
            NSString *versionCode = [result objectForKey:@"version_code"];
            NSArray *descs = [result objectForKey:@"feature_descriptions"];
            
            if([flag isEqualToString:@"yes"]){
                info = [[LosVersionInfo alloc] initWithState:YES flag:YES code:versionCode descs:descs];
            }else{
                info = [[LosVersionInfo alloc] initWithState:YES flag:NO code:versionCode descs:descs];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AppUpdateView* myView = (AppUpdateView*)self.view;
                [myView reload];
            });
        }];
    });
}

#pragma mark - delegate

-(void) update
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.yilos.com/portal/nail/download.html"]];
}

-(BOOL) checkDone
{
    return info.done;
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
