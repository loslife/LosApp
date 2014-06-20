#import "AddShopViewController.h"
#import "AddShopView.h"

@implementation AddShopViewController

{
    NSTimer *timer;
    int resendCountdown;
    LosHttpHelper *httpHelper;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        httpHelper = [[LosHttpHelper alloc] init];
    }
    return self;
}

-(void) loadView
{
    AddShopView *view = [[AddShopView alloc] initWithController:self];
    self.view = view;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void) viewDidAppear:(BOOL)animated
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    if(button.enabled){
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) requireVerificationCode
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    
    BOOL flag = [self checkPhone:phone.text];
    if(!flag){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL network = [LosHttpHelper isNetworkAvailable];
        if(!network){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network_unavailable", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSString *url = [NSString stringWithFormat:GET_CODE_URL,phone.text, @"attach"];
        [httpHelper getSecure:url completionHandler:^(NSDictionary *dict){
            
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self disableRequireCodeButton];
                [self startTick];
            });
        }];
    });
}

-(void) appendEnterprise
{
    AddShopView *myView = (AddShopView*)self.view;
    UITextField *phone = myView.phone;
    UITextField *code = myView.code;
    
    BOOL inputCheck;
    
    inputCheck = [self checkPhone:phone.text];
    if(!inputCheck){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确手机号" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([@"" isEqualToString:code.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入验证码" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *checkCodeURL = [NSString stringWithFormat:CHECK_CODE_URL,phone.text, @"attach", code.text];
    [httpHelper getSecure:checkCodeURL completionHandler:^(NSDictionary *dict){
        
        if(dict == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"校验验证码失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        NSNumber *code = [dict objectForKey:@"code"];
        if([code intValue] != 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"验证码错误" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                [alert show];
            });
            return;
        }
        
        UserData *userData = [UserData load];
        
        NSString *body = [NSString stringWithFormat:@"account=%@&enterprise_account=%@", userData.userId, phone.text];
        NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        [httpHelper postSecure:APPEND_ENERPRISE_URL Data:postData completionHandler:^(NSDictionary *dict){
        
            if(dict == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败，请联系客服" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联失败" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                return;
            }
            
            
            NSDictionary *result = [dict objectForKey:@"result"];
            NSString *enterpriseId = [result objectForKey:@"enterprise_id"];
            NSString *enterpriseName = [result objectForKey:@"enterprise_name"];
            
            NSString *insert = @"insert into enterprises (enterprise_Id, enterprise_name, latest_sync, display, create_date) values (:enterpriseId, :name, :latestSync, :display, :createDate);";
            
            NSString *dbFilePath = [PathResolver databaseFilePath];
            FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
            [db open];
            
            [db executeUpdate:insert, enterpriseId, enterpriseName, [NSNumber numberWithInt:0], @"yes", [NSNumber numberWithLongLong:[TimesHelper now]]];
            
            [db close];
            
            NSString *url = [NSString stringWithFormat:SYNC_MEMBERS_URL, enterpriseId, @"1", @"0"];
            
            [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
                
                [self refreshMembers:dict enterpriseId:enterpriseId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关联成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"button_confirm", @"") otherButtonTitles:nil];
                    [alert show];
                });
                
            }];
            
        }];
    }];
}

#pragma mark - timer

-(void) disableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = NO;
    button.backgroundColor = [UIColor whiteColor];
}

-(void) startTick
{
    resendCountdown = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
}

-(void) countdown
{
    resendCountdown--;
    
    if(resendCountdown > 0){
        return;
    }
    
    [self enableRequireCodeButton];
    [timer invalidate];
}

-(void) enableRequireCodeButton
{
    AddShopView *myView = (AddShopView*)self.view;
    UIButton *button = myView.requireCodeButton;
    
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:181/255.0f green:233/255.0f blue:236/255.0f alpha:1.0f];
}

#pragma mark - private method

-(BOOL) checkPhone:(NSString*)phone
{
    NSString *phoneRegex = @"^((13)|(15)|(18))\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

-(void) refreshMembers:(NSDictionary*)dict enterpriseId:(NSString*)enterpriseId
{
    NSDictionary *response = [dict objectForKey:@"result"];
    NSNumber *lastSync = [response objectForKey:@"last_sync"];
    NSDictionary *records = [response objectForKey:@"records"];
    
    NSString *dbFilePath = [PathResolver databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    [db open];
    
    // 刷新最后同步时间
    NSString *refreshLatestSyncTime = @"update enterprises set latest_sync = :sync where enterprise_id = :enterpriseId;";
    [db executeUpdate:refreshLatestSyncTime, lastSync, enterpriseId];
    
    // 处理新增记录
    NSArray *add = [records objectForKey:@"add"];
    NSString *insert = @"insert into members (id, enterprise_id, name, create_date, modify_date) values (:id, :eid, :name, :cdate, :mdate);";
    
    for(NSDictionary *item in add){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *createDate = [item objectForKey:@"create_date"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:insert, pk, enterpriseId, name, createDate, modifyDate];
    }
    
    // 处理更新记录
    NSArray *update = [records objectForKey:@"update"];
    NSString *statement = @"update members set name = :name, modify_date = :mdate where id = :id";
    
    for(NSDictionary *item in update){
        NSString *pk = [item objectForKey:@"id"];
        NSString *name = [item objectForKey:@"name"];
        NSNumber *modifyDate = [item objectForKey:@"modify_date"];
        [db executeUpdate:statement, name, modifyDate, pk];
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
