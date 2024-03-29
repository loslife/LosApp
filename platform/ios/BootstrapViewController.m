#import "BootstrapViewController.h"
#import "BootstrapView.h"
#import "LosDatabaseHelper.h"
#import "TimesHelper.h"

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
        
        [LosDatabaseHelper refreshDatabaseFile];// 刷新数据库文件路径，因为可能切换了用户
        
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
        
        NSString *url = [NSString stringWithFormat:FETCH_ENTERPRISES_URL, userId];
        [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
            
            NSDictionary *result = [dict objectForKey:@"result"];
            NSArray *enterprises = [result objectForKey:@"myShopList"];
            [self refreshEnterprises:enterprises];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                [self jumpToMain];
            });
        }];
    });
}

-(void) refreshEnterprises:(NSArray*)enterprises
{
    NSString *query = @"select count(1) as count from enterprises where enterprise_id = :enterpriseId;";
    NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, contact_latest_sync, display, default_shop, create_date, contact_has_sync, enterprise_account) values (:enterpriseId, :name, :contactLatestSync, :display, :default, :createDate, :flag, :account);";
    NSString *update = @"update enterprises set enterprise_name = :name where enterprise_id = :id";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    for(NSDictionary *item in enterprises){
        
        NSString *enterpriseId = [item objectForKey:@"enterprise_id"];
        NSString *enterpriseName = [item objectForKey:@"enterprise_name"];
        NSString *enterpriseAccount = [item objectForKey:@"enterprise_account"];
        
        FMResultSet *rs = [db executeQuery:query, enterpriseId];
        [rs next];
        int count = [[rs objectForColumnName:@"count"] intValue];
        if(count == 0){
            [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithInt:0], [NSNumber numberWithLongLong:[TimesHelper now]], @"no", enterpriseAccount];
        }else{
            [db executeUpdate:update, enterpriseName, enterpriseId];
        }
    }
    
    [db close];
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
    NSString *insertSystemConfig = @"insert into system_config values (1, 'version', :version);";
    NSString *insertSystemConfig2 = @"insert into system_config values (2, 'first_use', 'yes');";
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    [db executeUpdate:createTableSystemConfig];
    [db executeUpdate:insertSystemConfig, version];
    [db executeUpdate:insertSystemConfig2];
    
    [db close];
}

-(void) createOtherTables
{
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS enterprises (id integer primary key autoincrement, enterprise_id varchar(64), enterprise_name varchar(64), enterprise_account varchar(32), contact_latest_sync REAL, contact_has_sync varchar(8), display varchar(8), default_shop integer, create_date REAL);";
    
    NSString *sql2 = @"CREATE TABLE IF NOT EXISTS members (id varchar(64) primary key, enterprise_id varchar(64), name varchar(32), birthday REAL, phoneMobile varchar(16), joinDate REAL, memberNo varchar(32), latestConsumeTime REAL, totalConsume REAL, averageConsume REAL, create_date REAL, modify_date REAL, cardStr varchar(128), sex integer, sectionNumber integer);";
    
    NSString *sql3 = @"CREATE TABLE IF NOT EXISTS employee_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql4 = @"CREATE TABLE IF NOT EXISTS employee_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql5 = @"CREATE TABLE IF NOT EXISTS employee_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, employee_id varchar(64), employee_name varchar(16), year integer, month integer, day integer);";
    
    NSString *sql6 = @"CREATE TABLE IF NOT EXISTS biz_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql7 = @"CREATE TABLE IF NOT EXISTS biz_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql8 = @"CREATE TABLE IF NOT EXISTS biz_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, cash REAL, card REAL, bank REAL, service REAL, product REAL, newcard REAL, recharge REAL, create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql9 = @"CREATE TABLE IF NOT EXISTS service_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql10 = @"CREATE TABLE IF NOT EXISTS service_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql11 = @"CREATE TABLE IF NOT EXISTS service_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total REAL, project_id varchar(64), project_name varchar(32), project_cateName varchar(32), project_cateId varchar(64), create_date REAL, modify_date REAL, year integer, month integer, day integer);";
    
    NSString *sql12 = @"CREATE TABLE IF NOT EXISTS customer_count_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    NSString *sql13 = @"CREATE TABLE IF NOT EXISTS customer_count_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    NSString *sql14 = @"CREATE TABLE IF NOT EXISTS customer_count_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), walkin integer, member integer, year integer, month integer, day integer, hour integer, dateTime REAL);";
    
    NSString *sql15 = @"CREATE TABLE IF NOT EXISTS income_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
    
    NSString *sql16 = @"CREATE TABLE IF NOT EXISTS income_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
    
    NSString *sql17 = @"CREATE TABLE IF NOT EXISTS income_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
    
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
    [db executeUpdate:sql9];
    [db executeUpdate:sql10];
    [db executeUpdate:sql11];
    [db executeUpdate:sql12];
    [db executeUpdate:sql13];
    [db executeUpdate:sql14];
    [db executeUpdate:sql15];
    [db executeUpdate:sql16];
    [db executeUpdate:sql17];
    
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
    
    FMResultSet *rs = [db executeQuery:@"select enterprise_id from enterprises where display = 'yes' order by id asc"];
    if([rs next]){
        NSString *enterpriseId = [rs objectForColumnName:@"enterprise_id"];
        [UserData writeCurrentEnterprise:enterpriseId];
    }
    
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
}

@end
