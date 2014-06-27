#import <UIKit/UIKit.h>

typedef enum {
    DateDisplayTypeDay = 0,
    DateDisplayTypeMonth,
    DateDisplayTypeWeek,
} DateDisplayType;

@protocol LosTimePickerDelegate <NSObject>

-(void) dateSelected:(NSDate*)date;

@end

@interface LosTimePicker : UIView

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosTimePickerDelegate>)delegate InitDate:(NSDate*)date type:(DateDisplayType)type;

@end
