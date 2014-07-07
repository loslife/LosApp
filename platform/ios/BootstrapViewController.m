#import "BootstrapViewController.h"
#import "BootstrapView.h"

@implementation BootstrapViewController

{
    UpdateHelper *updateHelper;
    LosHttpHelper *httpHelper;
    SyncService *syncService;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        updateHelper = [[UpdateHelper alloc] init];
        httpHelper = [[LosHttpHelper alloc] init];
        syncService = [[SyncService alloc] init];
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
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:CGPointMake(160, 250)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
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
                [indicator stopAnimating];
                [self jumpToMain];
            });
            return;
        }
        
        // 有网络，尝试拉取最新数据
        UserData *userData = [UserData load];
        NSString *userId = userData.userId;
        
        [syncService refreshAttachEnterprisesUserId:userId Block:^(BOOL flag){
        
            if(!flag){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    [self jumpToMain];
                });
                return;
            }
            
            NSString *dbFilePath = [PathResolver databaseFilePath];
            FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
            [db open];
            
            NSString *sql = @"select enterprise_id, contact_latest_sync from enterprises";
            FMResultSet *rs = [db executeQuery:sql];
            
            dispatch_group_t group = dispatch_group_create();
            
            while([rs next]){
                
                NSString *enterpriseId = [rs objectForColumnName:@"enterprise_id"];
                
                NSNumber *contactLatestSync = [rs objectForColumnName:@"contact_latest_sync"];
                if([contactLatestSync isEqual:[NSNull null]]){
                    contactLatestSync = [NSNumber numberWithInt:0];
                }
                
                dispatch_group_enter(group);
                [syncService refreshMembersWithEnterpriseId:enterpriseId LatestSyncTime:contactLatestSync Block:^(BOOL flag){
                    dispatch_group_leave(group);
                }];
            }
            
            [db close];
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
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
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS enterprises (id integer primary key autoincrement, enterprise_id varchar(64), enterprise_name varchar(64), contact_latest_sync REAL, display varchar(8), default_shop integer, create_date REAL);";
    
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), birthday REAL, phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), latestConsumeTime REAL, totalConsume REAL, averageConsume REAL, create_date REAL, modify_date REAL);";
    
    NSString *sql3 = @"CREATE TABLE IF NOT EXISTS employee_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql4 = @"CREATE TABLE IF NOT EXISTS employee_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql5 = @"CREATE TABLE IF NOT EXISTS employee_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql6 = @"CREATE TABLE IF NOT EXISTS biz_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql7 = @"CREATE TABLE IF NOT EXISTS biz_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql8 = @"CREATE TABLE IF NOT EXISTS biz_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:sql1];
    [db executeUpdate:sql2];
    [db executeUpdate:sql3];
    [db executeUpdate:sql4];
    [db executeUpdate:sql5];
    [db executeUpdate:sql6];
    [db executeUpdate:sql7];
    [db executeUpdate:sql8];
    
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

#pragma mark - page jump

-(void) jumpToMain
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_id from enterprises order by id asc"];
    if([rs next]){
        NSString *enterpriseId = [rs objectForColumnName:@"enterprise_id"];
        [UserData writeCurrentEnterprise:enterpriseId];
    }
    
    [db close];
    
    UITabBarController *mainViewController = [[UITabBarController alloc] init];
    
    ReportEmployeeViewController *reportViewController = [[ReportEmployeeViewController alloc] init];
    UINavigationController *reportNav = [[UINavigationController alloc] initWithRootViewController:reportViewController];
    
    ContactViewController *contactViewController = [[ContactViewController alloc] init];
    UINavigationController *contactNav = [[UINavigationController alloc] initWithRootViewController:contactViewController];
    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    
    mainViewController.viewControllers = @[reportNav, contactNav, settingNav];
    [self presentViewController:mainViewController animated:YES completion:nil];
}

@end
