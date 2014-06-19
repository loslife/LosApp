#import "ContactView.h"

@implementation ContactView

{
    UISearchBar *searchBar;
}

-(id) initWithController:(ContactViewController*)controller
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    if (self) {
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        header.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.text = @"会员";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f];
        
        UIImage *magnifier = [UIImage imageNamed:@"magnifier"];
        UIButton *search = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        search.frame = CGRectMake(10, 10, 20, 20);
        [search setImage:magnifier forState:UIControlStateNormal];
        [search setTintColor:[UIColor colorWithRed:18/255.0f green:172/255.0f blue:182/255.0f alpha:1.0f]];
        [search addTarget:controller action:@selector(searchButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [header addSubview:label];
        [header addSubview:search];
        
        self.dataSource = controller;
        self.delegate = controller;
        self.tableHeaderView = header;
        [self setSeparatorInset:UIEdgeInsetsZero];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(hideSearchBar)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

@end
