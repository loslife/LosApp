#import "LosDatabaseHelper.h"
#import "PathResolver.h"

@implementation LosDatabaseHelper

{
    FMDatabaseQueue* queue;
}

-(id) init
{
    self = [super init];
    if(self){
        NSString *dbFilePath = [PathResolver databaseFilePath];
        queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    }
    return self;
}

+(LosDatabaseHelper*) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+(void) refreshDatabaseFile
{
    LosDatabaseHelper *instance = [self sharedInstance];
    [instance doRefresh];
}

-(void) doRefresh
{
    NSString *dbFilePath = [PathResolver databaseFilePath];
    queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
}

-(void) inDatabase:(void(^)(FMDatabase*))block
{
    [queue inDatabase:^(FMDatabase *db){
        block(db);
    }];
}

@end
