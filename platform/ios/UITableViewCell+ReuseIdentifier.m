#import "UITableViewCell+ReuseIdentifier.h"

@implementation UITableViewCell (ReuseIdentifier)

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
