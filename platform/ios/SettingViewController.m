#import "SettingViewController.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "SettingView.h"
#import "AddShopViewController.h"
#import "PasswordViewController.h"
#import "AboutUsViewController.h"
#import "LosAppDelegate.h"
#import "UserData.h"
#import "LosStyles.h"
#import "AppUpdateViewController.h"
#import "LosHttpHelper.h"

typedef enum {
    NewVersionStatusYes = 0,
    NewVersionStatusNo,
    NewVersionStatusNotNetwork,
} NewVersionStatus;

@interface MenuItem : NSObject

@property int index;
@property NSString* title;
@property NSString* image;

-(id) initWithIndex:(int)index title:(NSString*)title image:(NSString*)image;

@end

@implementation MenuItem

-(id) initWithIndex:(int)index title:(NSString*)title image:(NSString*)image
{
    self = [super init];
    if(self){
        self.index = index;
        self.title = title;
        self.image = image;
    }
    return self;
}

@end

@implementation SettingViewController

{
    NSArray *menus;
    LosHttpHelper *httpHelper;
    NewVersionStatus versionStatus;
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        
        httpHelper = [[LosHttpHelper alloc] init];
        versionStatus = NewVersionStatusNo;
        
        MenuItem *addShop = [[MenuItem alloc] initWithIndex:1 title:@"关联店铺" image:@"add_shop"];
        MenuItem *modifyPassword = [[MenuItem alloc] initWithIndex:2 title:@"修改密码" image:@"modify_password"];
        MenuItem *aboutUs = [[MenuItem alloc] initWithIndex:3 title:@"关于乐斯" image:@"about_us"];
        MenuItem *appUpdate = [[MenuItem alloc] initWithIndex:4 title:@"版本更新" image:@"app_update"];
        MenuItem *quitApp = [[MenuItem alloc] initWithIndex:5 title:@"退出登录" image:@"quit_app"];
        menus = @[addShop, modifyPassword, aboutUs, appUpdate, quitApp];
        
        self.navigationItem.title = @"设置";
        
        self.tabBarItem.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting"];
    }
    return self;
}

-(void) loadView
{
    SettingView *view = [[SettingView alloc] initWithController:self];
    self.view = view;
}

-(void) viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if(![LosHttpHelper isNetworkAvailable]){
            versionStatus = NewVersionStatusNotNetwork;
            [self refreshUpdateAccessory];
            return;
        }
        
        NSString *url = [NSString stringWithFormat:CHECK_NEW_VERSION, VERSION_CODE];
        [httpHelper getSecure:url completionHandler:^(NSDictionary* dict){
            
            if(dict == nil){
                versionStatus = NewVersionStatusNo;
                [self refreshUpdateAccessory];
                return;
            }
            
            NSNumber *code = [dict objectForKey:@"code"];
            if([code intValue] != 0){
                versionStatus = NewVersionStatusNo;
                [self refreshUpdateAccessory];
                return;
            }
            
            NSDictionary *result = [dict objectForKey:@"result"];
            NSString *flag = [result objectForKey:@"has_new_version"];
            if([flag isEqualToString:@"yes"]){
                versionStatus = NewVersionStatusYes;
                [self refreshUpdateAccessory];
            }else{
                versionStatus = NewVersionStatusNo;
                [self refreshUpdateAccessory];
            }
        }];
    });
}

// invoked in background thread
-(void) refreshUpdateAccessory
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
    SettingView *myView = (SettingView*)self.view;
    UITableViewCell *cellOfUpdate = [myView.tableView cellForRowAtIndexPath:indexPath];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(versionStatus == NewVersionStatusYes){
            cellOfUpdate.textLabel.text = @"版本更新";
            cellOfUpdate.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_yes"]];
        }else{
            cellOfUpdate.textLabel.text = @"已经是最新版本";
            cellOfUpdate.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_no"]];
        }
    });
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    MenuItem *item;
    
    if(indexPath.section == 0){
        item = [menus objectAtIndex:indexPath.row];
    }else{
        item = [menus objectAtIndex:4];
    }
    
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:item.image];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *item;
    
    if(indexPath.section == 0){
        item = [menus objectAtIndex:indexPath.row];
    }else{
        item = [menus objectAtIndex:4];
    }
    
    int index = item.index;
    
    if(index == 1){
        AddShopViewController *controller = [[AddShopViewController alloc] init];
        controller.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if(index == 2){
        PasswordViewController *controller = [[PasswordViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if(index == 3){
        AboutUsViewController *controller = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if(index == 4){
        
        if(versionStatus != NewVersionStatusYes){
            return;
        }
        
        AppUpdateViewController *controller = [[AppUpdateViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if(index == 5){
        
        UserData *userData = [UserData load];
        NSString *message = [NSString stringWithFormat:@"退出不删除任何历史数据，下次登录依然可以使用本账号（%@）。", userData.userId];
        
        LXActionSheet *logoutConfirm = [[LXActionSheet alloc]initWithTitle:message delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [logoutConfirm show];
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *bar = [[UILabel alloc] init];
    bar.backgroundColor = GRAY1;
    return bar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    
}

- (void)didClickOnDestructiveButton
{
    [UserData remove];
    LosAppDelegate* appDelegate = (LosAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
