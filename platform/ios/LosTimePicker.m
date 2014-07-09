#import "LosTimePicker.h"

@implementation LosTimePicker

{
    NSDate *currentDate;
    DateDisplayType dateType;
    id<LosTimePickerDelegate> myDelegate;
    
    UILabel *label;
    UIButton *displayTag;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosTimePickerDelegate>)delegate InitDate:(NSDate*)date type:(DateDisplayType)type
{
    self = [super initWithFrame:frame];
    if(self){
        
        currentDate = date;
        dateType = type;
        myDelegate = delegate;
        
        UIButton *previous = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        previous.frame = CGRectMake(60, 10, 20, 20);
        [previous setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [previous addTarget:self action:@selector(previousDate) forControlEvents:UIControlEventTouchUpInside];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 40)];
        label.text = [self resolveDateLabel];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        
        UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        next.frame = CGRectMake(240, 10, 20, 20);
        [next setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [next addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
        
        displayTag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        displayTag.frame = CGRectMake(275, 0, 40, 40);
        [displayTag setTitle:[self resolveDisplayTag] forState:UIControlStateNormal];
        [displayTag addTarget:self action:@selector(switchDateType) forControlEvents:UIControlEventTouchUpInside];

        self.backgroundColor = [UIColor colorWithRed:247/255.0f green:248/255.0f blue:249/255.0f alpha:1.0f];
        [self addSubview:previous];
        [self addSubview:label];
        [self addSubview:next];
        [self addSubview:displayTag];
    }
    return self;
}

#pragma mark - button pressed

-(void) previousDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:currentDate];
    
    if(dateType == DateDisplayTypeDay){
        components.day --;
    }else if (dateType == DateDisplayTypeMonth){
        components.month --;
    }else{
        components.weekOfYear --;
    }
    NSDate *yesterday = [calendar dateFromComponents:components];
    
    currentDate = yesterday;
    
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType];
}

-(void) nextDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear fromDate:currentDate];
    
    if(dateType == DateDisplayTypeDay){
        components.day ++;
    }else if (dateType == DateDisplayTypeMonth){
        components.month ++;
    }else{
        components.weekOfYear ++;
    }
    NSDate *tomorrow = [calendar dateFromComponents:components];
    
    currentDate = tomorrow;
    
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType];
}

-(void) switchDateType
{
    dateType++;
    if(dateType > DateDisplayTypeWeek){
        dateType = DateDisplayTypeDay;
    }
    
    [displayTag setTitle:[self resolveDisplayTag] forState:UIControlStateNormal];
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType];
}

#pragma mark - change label text

-(NSString*) resolveDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(dateType == DateDisplayTypeDay){
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }else if(dateType == DateDisplayTypeMonth){
        [dateFormatter setDateFormat:@"yyyy年MM月"];
    }else{
        [dateFormatter setDateFormat:@"ww周"];
    }
    
    return [dateFormatter stringFromDate:currentDate];
}

-(NSString*) resolveDisplayTag
{
    if(dateType == DateDisplayTypeDay){
        return @"日";
    }else if(dateType == DateDisplayTypeMonth){
        return @"月";
    }else{
        return @"周";
    }
}

@end
