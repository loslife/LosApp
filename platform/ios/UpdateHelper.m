#import "UpdateHelper.h"

@implementation UpdateHelper

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
}

@end
