#import "UpdateHelper.h"
#import "Script_100_110.h"

@implementation UpdateHelper

{
    Script_100_110 *script1;
}

-(id) init
{
    self = [super init];
    if(self){
        script1 = [[Script_100_110 alloc] init];
    }
    return self;
}

-(void) doUpdate:(VersionInfo*)versionInfo
{
    NSString *oldVersion = [versionInfo oldVersion];
    NSString *currentVersion = [versionInfo currentVersion];
    
    // 全新安装，不执行升级脚本
    if([oldVersion isEqualToString:@"0"]){
        return;
    }
    
    // 正常登陆，不执行升级脚本
    if([oldVersion isEqualToString:currentVersion]){
        return;
    }
    
    // 以下均是版本升级，需要数据迁移
    if([oldVersion isEqualToString:@"1.0.0"]){
        [script1 exec];
    }
}

@end