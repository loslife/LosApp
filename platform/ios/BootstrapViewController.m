#import "BootstrapViewController.h"
#import "BootstrapView.h"

@implementation BootstrapViewController

{
    UpdateHelper *updateHelper;
    LosHttpHelper *httpHelper;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        updateHelper = [[UpdateHelper alloc] init];
        httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

-(void) loadView
{
    BootstrapView *view = [[BootstrapView alloc] init];
    self.view = view;
}

-(void) viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        VersionInfo *versionInfo = [[VersionInfo alloc] init];
        
        if([versionInfo needInit]){
            [self mkdirAndDatabaseFile];
            [self createSystemTables:[versionInfo currentVersion]];
            [self createOtherTables];
        }else{
            [self refreshVersion:[versionInfo currentVersion]];
        }
        
        [updateHelper doUpdate:versionInfo];
        
        UserData *userData = [UserData load];
        NSString *userId = userData.userId;
        
        NSString *fetchEnterprises = [NSString stringWithFormat:FETCH_ENTERPRISES_URL, userId];
        [httpHelper getSecure:fetchEnterprises completionHandler:^(NSDictionary* dict){
        
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                if(dict == nil){
                    // 报错
                }
                
                NSNumber *code = [dict objectForKey:@"code"];
                if([code intValue] != 0){
                    // 报错
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [self refreshAttachEnterprises:dict];
                    
                    NSString *dbFilePath = [PathResolver databaseFilePath];
                    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
                    [db open];
                    
                    dispatch_group_t group = dispatch_group_create();
                    
                    NSString *sql = @"select enterprise_id, latest_sync from enterprises";
                    FMResultSet *rs = [db executeQuery:sql];
                    while([rs next]){
                        
                        NSString *enterpriseId = [rs objectForColumnName:@"enterprise_id"];
                        NSNumber *latestSyncDate = [rs objectForColumnName:@"latest_sync"];
                            
                            
                        NSString *url = [NSString stringWithFormat:SYNC_MEMBERS_URL, enterpriseId, @"1", [latestSyncDate stringValue]];
                        
                        [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
                        
                            // 做些事
                            
                            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                                
                            
                            
                            });
                        
                        }];
                            
                            
                        
                    }
                    
                    
                    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        [db close];
                        
                        UITabBarController *mainViewController = [[UITabBarController alloc] init];
                        
                        ReportViewController *reportViewController = [[ReportViewController alloc] init];
                        UINavigationController *reportNav = [[UINavigationController alloc] initWithRootViewController:reportViewController];
                        
                        ContactViewController *contactViewController = [[ContactViewController alloc] init];
                        UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
                        
                        SettingViewController *settingViewController = [[SettingViewController alloc] init];
                        UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
                        
                        mainViewController.viewControllers = @[reportNav, contactNav, settingNav];
                        [self presentViewController:mainViewController animated:YES completion:nil];
                        
                    });
                });
            });
        }];
    });
}

#pragma mark - private method

-(void) mkdirAndDatabaseFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *userPath = [PathResolver currentUserDirPath];

    if(![fileManager fileExistsAtPath:userPath]){
        [fileManager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    [db close];
}

-(void) createSystemTables:(NSString*)version
{
    NSString *createTableSystemConfig = @"CREATE TABLE IF NOT EXISTS system_config (id integer primary key, key varchar(32), value varchar(32));";
    NSString *insertSystemConfig = @"insert into system_config values (1, 'version', :version)";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:createTableSystemConfig];
    [db executeUpdate:insertSystemConfig, version];
    
    [db close];
}

-(void) createOtherTables
{
    
}

-(void) refreshVersion:(NSString*)version
{
    NSString *updateVersion = @"update system_config set value = :version where key = 'version';";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    [db executeUpdate:updateVersion, version];
    [db close];
}

-(void) refreshAttachEnterprises:(NSDictionary*)dict
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, latest_sync, display, create_date) values (:enterpriseId, :latestSync, :dispaly, :createDate);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSArray *enterpriseIds = [dict objectForKey:@"result"];
    for(NSString *enterpriseId in enterpriseIds){
        
        FMResultSet *rs = [db executeQuery:query, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, enterpriseId, [NSNumber numberWithInt:0], @"no", [NSNumber numberWithLongLong:[TimesHelper now]]];
        }
    }
    
    [db close];
}

@end
