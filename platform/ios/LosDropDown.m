#import "LosDropDown.h"
#import "UITableViewCell+ReuseIdentifier.h"

@implementation LosDropDownItem

-(id) initWithTitle:(NSString*)title value:(NSString*)value
{
    self = [super init];
    if(self){
        self.title = title;
        self.value = value;
    }
    return self;
}

@end

@implementation LosDropDown

{
    NSArray *menuItems;
    id<LosDropDownDelegate> dropDownDelegate;
}

-(id) initWithFrame:(CGRect)frame MenuItems:(NSArray*)source Delegate:(id<LosDropDownDelegate>)delegate;
{
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    NSUInteger count = [source count];
    CGFloat calculatedHeight = height + (count - 1) * 28;
    
    self = [super initWithFrame:CGRectMake(x, y, width, calculatedHeight) style:UITableViewStylePlain];
    if(self){
        
        menuItems = source;
        dropDownDelegate = delegate;
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = [UIColor grayColor];
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    return self;
}

#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    LosDropDownItem *item = [menuItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LosDropDownItem *item = [menuItems objectAtIndex:indexPath.row];
    
    [dropDownDelegate menuItemTapped:item.value];
}

@end
