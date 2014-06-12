#import "VersionInfo.h"

@implementation VersionInfo

{
    NSString *oldVersion;
    NSString *currentVersion;
}

-(id) init
{
    self = [super init];
    if(self){
        [self initOldVersion];
        [self initCurrentVersion];
    }
    return self;
}

-(BOOL) needInit
{
    return [oldVersion isEqual: @"0"];
}

-(NSString*) oldVersion
{
    return oldVersion;
}

-(NSString*) currentVersion
{
    return currentVersion;
}

#pragma mark - private method

-(void) initOldVersion
{
    // 数据库文件不存在，oldVersion设为0
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbFilePath = [PathResolver databaseFilePath];
    if(![fileManager fileExistsAtPath:dbFilePath]){
        oldVersion = @"0";
        return;
    }
    
    // 数据库文件打开失败，oldVersion设为0
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if(![db open]){
        oldVersion = @"0";
        return;
    }

    FMResultSet *rs = [db executeQuery:@"select value from system_config where key = 'version';"];
    [rs next];
    oldVersion = [rs stringForColumn:@"value"];
    
    [db close];
}

-(void) initCurrentVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    currentVersion = versionNum;
}

@end
