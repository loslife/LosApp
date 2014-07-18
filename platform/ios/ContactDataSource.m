#import "ContactDataSource.h"
#import "Member.h"
#import "UITableViewCell+ReuseIdentifier.h"
#import "MemberDetailViewController.h"
#import "MemberTableViewCell.h"

@implementation ContactDataSource

{
    ContactViewController *controller;
}

-(id) initWithController:(ContactViewController*)viewController
{
    self = [super init];
    if(self){
        
        controller = viewController;
        
        self.members = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.members count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.members objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MemberTableViewCell reuseIdentifier]];
    if(!cell) {
        cell = [[MemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell reuseIdentifier]];
    }
    
    Member *member = [[self.members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = member.name;
    cell.cardsLabel.text = member.cardStr;
    cell.consumeLabel.text = member.consumeDesc;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{    
    if ([[self.members objectAtIndex:section] count] > 0) {
        return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView*)view;
    headerView.textLabel.text = [@"     " stringByAppendingString:headerView.textLabel.text];// sorry for this
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *member = [[self.members objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MemberDetailViewController *detail = [[MemberDetailViewController alloc] initWithMember:member];
    [controller.navigationController pushViewController:detail animated:YES];
}

@end
