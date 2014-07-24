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

@property NSString* title;
@property NSString* image;

-(id) initWithTitle:(NSString*)title Image:(NSString*)image;

@end

@implementation MenuItem

-(id) initWithTitle:(NSString*)title Image:(NSString*)image
{
    self = [super init];
    if(self){
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
        
        MenuItem *addShop = [[MenuItem alloc] initWithTitle:@"关联店铺" Image:@"add_shop"];
        MenuItem *modifyPassword = [[MenuItem alloc] initWithTitle:@"修改密码" Image:@"modify_password"];
        MenuItem *aboutUs = [[MenuItem alloc] initWithTitle:@"关于乐斯" Image:@"about_us"];
        MenuItem *appUpdate = [[MenuItem alloc] initWithTitle:@"版本更新" Image:@"app_update"];
        MenuItem *quitApp = [[MenuItem alloc] initWithTitle:@"退出登录" Image:@"quit_app"];
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
            cellOfUpdate.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_yes"]];
        }else if(versionStatus == NewVersionStatusNo){
            cellOfUpdate.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_no"]];
        }else if(versionStatus == NewVersionStatusNotNetwork){
            cellOfUpdate.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_no"]];
        }
    });
}

#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [UserData remove];
        LosAppDelegate* appDelegate = (LosAppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        SettingView *myView = (SettingView*)self.view;
        [myView.tableView deselectRowAtIndexPath:[myView.tableView indexPathForSelectedRow] animated:YES];
    }
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
    
    NSString *title = item.title;
    
    if([title isEqualToString:@"关联店铺"]){
        AddShopViewController *controller = [[AddShopViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([title isEqualToString:@"修改密码"]){
        PasswordViewController *controller = [[PasswordViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([title isEqualToString:@"关于乐斯"]){
        AboutUsViewController *controller = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([title isEqualToString:@"版本更新"]){
        
        if(versionStatus != NewVersionStatusYes){
            return;
        }
        
        AppUpdateViewController *controller = [[AppUpdateViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if([title isEqualToString:@"退出登录"]){
        UIActionSheet *logoutConfirm = [[UIActionSheet alloc] initWithTitle:@"退出不删除任何历史数据，下次登录依然可以使用本账号。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [logoutConfirm showFromTabBar:self.tabBarController.tabBar];
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

@end
