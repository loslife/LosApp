#import "SystemDao.h"
#import "LosDatabaseHelper.h"

@implementation SystemDao

{
    LosDatabaseHelper *dbHelper;
}

-(id) init
{
    self = [super init];
    if(self){
        dbHelper = [LosDatabaseHelper sharedInstance];
    }
    return self;
}

-(BOOL) queryFirstUse
{
    __block BOOL flag;
    
    [dbHelper inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery:@"select value from system_config where key = 'first_use';"];
        [rs next];
        NSString* value = [rs stringForColumn:@"value"];
        flag = [value isEqualToString:@"yes"];
        [rs close];
    }];
    
    return flag;
}

-(void) updateFirstUse
{
    [dbHelper inDatabase:^(FMDatabase *db){
        [db executeUpdate:@"update system_config set value = 'no' where key = 'first_use';"];
    }];
}

@end
