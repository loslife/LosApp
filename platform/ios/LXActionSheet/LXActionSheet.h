#import <UIKit/UIKit.h>

@protocol LXActionSheetDelegate <NSObject>

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex;

@optional

- (void)didClickOnDestructiveButton;
- (void)didClickOnCancelButton;

@end

@interface LXActionSheet : UIView

- (id)initWithTitle:(NSString *)title delegate:(id<LXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
- (void)show;

@end
