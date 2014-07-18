#import "MemberDao.h"
#import "PathResolver.h"
#import "FMDB.h"
#import "TimesHelper.h"
#import "Member.h"
#import "StringUtils.h"

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
    NSString *insert = @"insert into members (id, enterprise_id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume, create_date, modify_date, cardStr) values (:id, :eid, :name, :birthday, :phoneMobile, :joinDate, :memberNo, :latest, :total, :average, :cdate, :mdate, :cardStr);";
    
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
        NSString *cardStr = [item objectForKey:@"cardStr"];
        [db executeUpdate:insert, pk, enterpriseId, name, birthday, phone, joinDate, memberNo, latest, total, average, createDate, modifyDate, cardStr];
    }
    
    // 处理更新记录
    NSArray *update = [records objectForKey:@"update"];
    NSString *statement = @"update members set name = :name, birthday = :birthday, phoneMobile = :phone, joinDate = :joinDate, memberNo = :memberNo, latestConsumeTime = :latest, totalConsume = :total, averageConsume = :average, modify_date = :mdate, cardStr = :cardStr where id = :id";
    
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
        NSString *cardStr = [item objectForKey:@"cardStr"];
        [db executeUpdate:statement, name, birthday, phone, joinDate, memberNo, latest, total, average, modifyDate, cardStr, pk];
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

-(NSArray*) queryMembersByEnterpriseId:(NSString*)enterpriseId
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSMutableArray *members = [NSMutableArray arrayWithCapacity:1];
    
    NSString *statement = @"select id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume, cardStr from members where enterprise_id = :eid";
    
    FMResultSet *rs = [db executeQuery:statement, enterpriseId];
    while ([rs next]) {
        
        NSString *pk = [rs objectForColumnName:@"id"];
        NSString *name = [rs objectForColumnName:@"name"];
        NSNumber *birthday = [rs objectForColumnName:@"birthday"];
        NSString *phone = [rs objectForColumnName:@"phoneMobile"];
        NSNumber *joinDate = [rs objectForColumnName:@"joinDate"];
        NSString *memberNo = [rs objectForColumnName:@"memberNo"];
        NSNumber *latest = [rs objectForColumnName:@"latestConsumeTime"];
        NSNumber *totalConsume = [rs objectForColumnName:@"totalConsume"];
        NSNumber *averageConsume = [rs objectForColumnName:@"averageConsume"];
        NSString *cardStr = [rs objectForColumnName:@"cardStr"];
        NSString *desc = [self resolveConsumeDescWithDate:latest average:averageConsume];
        
        Member *member = [[Member alloc] initWithPk:pk Name:name Birthday:birthday Phone:phone JoinDate:joinDate MemberNo:memberNo LatestConsume:latest TotalConsume:totalConsume AverageConsume:averageConsume cardStr:cardStr desc:desc];
        [members addObject:member];
    }
    
    [db close];
    
    return members;
}

-(NSArray*) fuzzyQueryMembersByEnterpriseId:(NSString*)enterpriseId name:(NSString*)name
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    NSMutableArray *members = [NSMutableArray arrayWithCapacity:1];
    
    NSString *base = @"select id, name, birthday, phoneMobile, joinDate, memberNo, latestConsumeTime, totalConsume, averageConsume, cardStr from members where enterprise_id = :eid and name like '%%%@%%';";
    NSString *statement = [NSString stringWithFormat:base, name];
    
    FMResultSet *rs = [db executeQuery:statement, enterpriseId];
    while ([rs next]) {
        
        NSString *pk = [rs objectForColumnName:@"id"];
        NSString *name = [rs objectForColumnName:@"name"];
        NSNumber *birthday = [rs objectForColumnName:@"birthday"];
        NSString *phone = [rs objectForColumnName:@"phoneMobile"];
        NSNumber *joinDate = [rs objectForColumnName:@"joinDate"];
        NSString *memberNo = [rs objectForColumnName:@"memberNo"];
        NSNumber *latest = [rs objectForColumnName:@"latestConsumeTime"];
        NSNumber *totalConsume = [rs objectForColumnName:@"totalConsume"];
        NSNumber *averageConsume = [rs objectForColumnName:@"averageConsume"];
        NSString *cardStr = [rs objectForColumnName:@"cardStr"];
        NSString *desc = [self resolveConsumeDescWithDate:latest average:averageConsume];
        
        Member *member = [[Member alloc] initWithPk:pk Name:name Birthday:birthday Phone:phone JoinDate:joinDate MemberNo:memberNo LatestConsume:latest TotalConsume:totalConsume AverageConsume:averageConsume cardStr:cardStr desc:desc];
        [members addObject:member];
    }
    
    [db close];
    
    return members;
}

-(NSString*) resolveConsumeDescWithDate:(NSNumber*)date average:(NSNumber*)average
{
    NSString *latestConsumeStr = [StringUtils fromNumber:date format:@"MM月dd日"];
    if([StringUtils isEmpty:latestConsumeStr]){
        latestConsumeStr = @"未消费";
    }else{
        latestConsumeStr = [NSString stringWithFormat:@"最近消费%@", latestConsumeStr];
    }
    return [NSString stringWithFormat:@"%@ / 平均消费%d元", latestConsumeStr, [average intValue]];
}

@end
