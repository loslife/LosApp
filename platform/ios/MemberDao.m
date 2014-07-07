#import "MemberDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"

@implementation MemberDao

-(void) batchUpdateMembers:(NSDictionary*)records LastSync:(NSNumber*)lastSync EnterpriseId:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    // 刷新最后同步时间
    NSString *refreshLatestSyncTime = @"update enterprises set contact_latest_sync = :sync where enterprise_id = :enterpriseId;";
    [db executeUpdate:refreshLatestSyncTime, lastSync, enterpriseId];
    
    // 处理新增记录
    NSArray *add = [records objectForKey:@"add"];
    NSString *insert = @"insert into members (id, enterprise_id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume, create_date, modify_date) values (:id, :eid, :name, :birthday, :phoneMobile, :joinDate, :memberNo, :latest, :total, :average, :cdate, :mdate);";
    
    for(NSDictionary *item in add){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *birthday = [item objectForKey:@"birthday"];
        NSString *phone = [item objectForKey:@"phoneMobile"];
        NSNumber *joinDate = [item objectForKey:@"joinDate"];
        NSString *memberNo = [item objectForKey:@"memberNo"];
        NSNumber *latest = [item objectForKey:@"latestConsumeTime"];
        NSNumber *total = [item objectForKey:@"totalConsume"];
        NSNumber *average = [item objectForKey:@"averageConsume"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:insert, pk, enterpriseId, name, birthday, phone, joinDate, memberNo, latest, total, average, createDate, modifyDate];
    }
    
    // 处理更新记录
    NSArray *update = [records objectForKey:@"update"];
    NSString *statement = @"update members set name = :name, birthday = :birthday, phoneMobile = :phone, joinDate = :joinDate, memberNo = :memberNo, latestConsumeTime = :latest, totalConsume = :total, averageConsume = :average, modify_date = :mdate where id = :id";
    
    for(NSDictionary *item in update){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *birthday = [item objectForKey:@"birthday"];
        NSString *phone = [item objectForKey:@"phoneMobile"];
        NSNumber *joinDate = [item objectForKey:@"joinDate"];
        NSString *memberNo = [item objectForKey:@"memberNo"];
        NSNumber *latest = [item objectForKey:@"latestConsumeTime"];
        NSNumber *total = [item objectForKey:@"totalConsume"];
        NSNumber *average = [item objectForKey:@"averageConsume"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:statement, name, birthday, phone, joinDate, memberNo, latest, total, average, modifyDate, pk];
    }
    
    // 处理remove
    NSArray *remove = [records objectForKey:@"remove"];
    NSString *deleteStatement = @"delete from members where id = :id";
    
    for(NSDictionary *item in remove){
        NSString *pk = [item objectForKey:@"id"];
        [db executeUpdate:deleteStatement, pk];
    }
    
    [db close];
}

@end
