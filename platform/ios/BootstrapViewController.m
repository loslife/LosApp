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
        
        // 没有网络，直接进入主界面
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self jumpToMain];
            });
            return;
        }
        
        // 有网络，尝试拉取最新数据
        UserData *userData = [UserData load];
        NSString *userId = userData.userId;
        
        NSString *url = [NSString stringWithFormat:FETCH_ENTERPRISES_URL, userId];
        
        [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jumpToMain];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jumpToMain];
                });
                return;
            }
            
            [self refreshAttachEnterprises:dict];
            
            dispatch_group_t group = dispatch_group_create();
            
            NSString *dbFilePath = [PathResolver databaseFilePath];
            FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
            [db open];
            
            NSString *sql = @"select enterprise_id, latest_sync from enterprises";
            FMResultSet *rs = [db executeQuery:sql];
            
            while([rs next]){
                
                dispatch_group_enter(group);
                
                NSString *enterpriseId = [rs objectForColumnName:@"enterprise_id"];
                NSNumber *latestSyncDate = [rs objectForColumnName:@"latest_sync"];
                
                NSString *url = [NSString stringWithFormat:SYNC_MEMBERS_URL, enterpriseId, @"1", [latestSyncDate stringValue]];
                
                [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
                    
                    if(dict == nil){
                        dispatch_group_leave(group);
                        return;
                    }
                    
                    NSNumber *code = [dict objectForKey:@"code"];
                    if([code intValue] != 0){
                        dispatch_group_leave(group);
                        return;
                    }
                    
                    [self refreshMembers:dict enterpriseId:enterpriseId];
                    
                    dispatch_group_leave(group);
                }];
            }
            
            [db close];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [self jumpToMain];
            });
        }];
    });
}

#pragma mark - system initial

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
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS enterprises (id integer primary key autoincrement, enterprise_id varchar(64), latest_sync REAL, display varchar(8), create_date REAL);";
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), create_date REAL, modify_date REAL);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:sql1];
    [db executeUpdate:sql2];
    
    [db close];
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

#pragma mark - sync datas from server

-(void) refreshAttachEnterprises:(NSDictionary*)dict
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, latest_sync, display, create_date) values (:enterpriseId, :latestSync, :display, :createDate);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSArray *enterpriseIds = [dict objectForKey:@"result"];
    for(NSDictionary *item in enterpriseIds){
        
        NSString *enterpriseId = [item objectForKey:@"enterprise_id"];
        FMResultSet *rs = [db executeQuery:query, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            BOOL result = [db executeUpdate:insert, enterpriseId, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithLongLong:[TimesHelper now]]];
            if(!result){
                NSLog(@"%@", [db lastErrorMessage]);
            }
        }
    }
    
    [db close];
}

-(void) refreshMembers:(NSDictionary*)dict enterpriseId:(NSString*)enterpriseId
{
    NSDictionary *response = [dict objectForKey:@"result"];
    NSNumber *lastSync = [response objectForKey:@"last_sync"];
    NSDictionary *records = [response objectForKey:@"records"];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    // 刷新最后同步时间
    NSString *refreshLatestSyncTime = @"update enterprises set latest_sync = :sync where enterprise_id = :enterpriseId;";
    [db executeUpdate:refreshLatestSyncTime, lastSync, enterpriseId];
    
    // 处理新增记录
    NSArray *add = [records objectForKey:@"add"];
    NSString *insert = @"insert into members (id, enterprise_id, name, create_date, modify_date) values (:id, :eid, :name, :cdate, :mdate);";
    
    for(NSDictionary *item in add){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:insert, pk, enterpriseId, name, createDate, modifyDate];
    }
    
    // 处理update
    // 处理remove
    
    [db close];
}

#pragma mark - page jump

-(void) jumpToMain
{
    UITabBarController *mainViewController = [[UITabBarController alloc] init];
    
    ReportViewController *reportViewController = [[ReportViewController alloc] init];
    UINavigationController *reportNav = [[UINavigationController alloc] initWithRootViewController:reportViewController];
    
    ContactViewController *contactViewController = [[ContactViewController alloc] init];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    mainViewController.viewControllers = @[reportNav, contactNav, settingNav];
    [self presentViewController:mainViewController animated:YES completion:nil];
}

@end
