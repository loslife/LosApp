#import "SettingViewController.h"
#import "UITableViewCell+ReuseIdentifier.h"

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
}

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){

        MenuItem *addShop = [[MenuItem alloc] initWithTitle:@"关联店铺" Image:@"add_shop"];
        MenuItem *modifyPassword = [[MenuItem alloc] initWithTitle:@"修改密码" Image:@"modify_password"];
        MenuItem *aboutUs = [[MenuItem alloc] initWithTitle:@"关于乐斯" Image:@"about_us"];
        menus = @[addShop, modifyPassword, aboutUs];
        
        self.navigationItem.title = @"设置";
        
        self.tabBarItem.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_setting"];
    }
    return self;
}

-(void) viewDidLoad
{
    [self.tableView setScrollEnabled:NO];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    MenuItem *item = [menus objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.imageView.image = [UIImage imageNamed:item.image];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

@end
