#import "Script_100_110.h"
#import "LosDatabaseHelper.h"

@implementation Script_100_110

-(void) exec
{
    LosDatabaseHelper *dbHelper = [LosDatabaseHelper sharedInstance];
    
    [dbHelper inDatabase:^(FMDatabase *db){
    
        NSString *sql1 = @"CREATE TABLE IF NOT EXISTS income_performance_day (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
        
        NSString *sql2 = @"CREATE TABLE IF NOT EXISTS income_performance_month (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
        
        NSString *sql3 = @"CREATE TABLE IF NOT EXISTS income_performance_week (id varchar(64) NOT NULL primary key, enterprise_id varchar(64), total_income REAL, total_prepay REAL, total_paidin REAL, total_paidin_bank REAL, total_paidin_cash REAL, service_cash REAL, service_bank REAL, product_cash REAL, product_bank REAL, card REAL, newcard_cash REAL, newcard_bank REAL, rechargecard_cash REAL, rechargecard_bank REAL, year integer, month integer, day integer, create_date REAL, modify_date REAL);";
        
        [db executeUpdate:sql1];
        [db executeUpdate:sql2];
        [db executeUpdate:sql3];
    }];
}

@end
