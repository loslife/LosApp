#import "LosTimePicker.h"
#import "TimesHelper.h"
#import "LosStyles.h"

@implementation LosTimePicker

{
    NSDate *currentDate;
    DateDisplayType dateType;
    id<LosTimePickerDelegate> myDelegate;
    
    UILabel *label;
    
    UIButton *displayTag;
    UIButton *previous;
    UIButton *next;
}

-(id) initWithFrame:(CGRect)frame Delegate:(id<LosTimePickerDelegate>)delegate InitDate:(NSDate*)date type:(DateDisplayType)type
{
    self = [super initWithFrame:frame];
    if(self){
        
        currentDate = date;
        dateType = type;
        myDelegate = delegate;
        
        previous = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        previous.frame = CGRectMake(40, 0, 40, 40);
        [previous setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [previous addTarget:self action:@selector(previousDate) forControlEvents:UIControlEventTouchUpInside];
        previous.tintColor = BLUE1;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 40)];
        label.text = [self resolveDateLabel];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        
        next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        next.frame = CGRectMake(240, 0, 40, 40);
        [next setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [next addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
        next.tintColor = BLUE1;
        
        displayTag = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        displayTag.frame = CGRectMake(275, 0, 40, 40);
        [displayTag setTitle:[self resolveDisplayTag] forState:UIControlStateNormal];
        [displayTag addTarget:self action:@selector(switchDateType) forControlEvents:UIControlEventTouchUpInside];
        displayTag.tintColor = BLUE1;

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
    [self disableButtons];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components;
    
    if(dateType == DateDisplayTypeDay){
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
        components.day --;
    }else if (dateType == DateDisplayTypeMonth){
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
        components.month --;
    }else{
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday fromDate:currentDate];
        components.weekOfYear --;
    }
    
    NSDate *previousDate = [calendar dateFromComponents:components];
    currentDate = previousDate;
    
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType completion:^{
        [self enableButtons];
    }];
}

-(void) nextDate
{
    [self disableButtons];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components;
    
    if(dateType == DateDisplayTypeDay){
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
        components.day ++;
    }else if (dateType == DateDisplayTypeMonth){
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
        components.month ++;
    }else{
        components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday fromDate:currentDate];
        components.weekOfYear ++;
    }
    
    NSDate *nextDate = [calendar dateFromComponents:components];
    currentDate = nextDate;
    
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType completion:^{
        [self enableButtons];
    }];
}

-(void) switchDateType
{
    [self disableButtons];
    
    dateType++;
    if(dateType > DateDisplayTypeWeek){
        dateType = DateDisplayTypeDay;
    }
    
    [displayTag setTitle:[self resolveDisplayTag] forState:UIControlStateNormal];
    label.text = [self resolveDateLabel];
    [myDelegate dateSelected:currentDate Type:dateType completion:^{
        [self enableButtons];
    }];
}

#pragma mark - change label text

-(void) disableButtons
{
    previous.enabled = NO;
    next.enabled = NO;
    displayTag.enabled = NO;
}

-(void) enableButtons
{
    previous.enabled = YES;
    next.enabled = YES;
    displayTag.enabled = YES;
}

-(NSString*) resolveDateLabel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(dateType == DateDisplayTypeDay){
        
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        return [dateFormatter stringFromDate:currentDate];
    }else if(dateType == DateDisplayTypeMonth){
        
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        return [dateFormatter stringFromDate:currentDate];
    }else{
        
        [dateFormatter setDateFormat:@"MM月dd日"];
        
        NSDate *sunday = [TimesHelper firstDayOfWeek:currentDate];
        NSDate *saturday = [TimesHelper lastDayOfWeek:currentDate];
        return [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:sunday], [dateFormatter stringFromDate:saturday]];
    }
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
