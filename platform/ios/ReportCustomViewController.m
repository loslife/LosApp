#import "ReportCustomViewController.h"
#import "ReportCustomView.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"
#import "CustomerCount.h"
#import "TimesHelper.h"

@implementation ReportCustomViewController

{
    NSMutableArray *records;
    NSMutableArray *top3;
}

-(id) init
{
    self = [super init];
    if(self){
        
        records = [NSMutableArray arrayWithCapacity:1];
        top3 = [NSMutableArray arrayWithCapacity:1];
        
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem = [[SwitchShopButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) Delegate:self];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    ReportCustomView *view = [[ReportCustomView alloc] initWithController:self];
    self.view = view;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [super initEnterprises];
        [self loadReport];
    });
}

-(void) loadReport
{
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    if([StringUtils isEmpty:currentEnterpriseId]){
        return;
    }
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    
    if(![LosHttpHelper isNetworkAvailable]){
        
        records = [self.reportDao queryCustomerCountByDate:status.date EnterpriseId:currentEnterpriseId Type:status.dateType];
        [self resolveTop3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportCustomView *myView = (ReportCustomView*)self.view;
            [myView reload];
        });
        
        return;
    }
    
    NSString *type = [status typeStr];
    
    NSString *url = [NSString stringWithFormat:FETCH_REPORT_URL, currentEnterpriseId, [status yearStr], [status monthStr], [status dayStr], type, @"customer"];
    
    [self.httpHelper getSecure:url completionHandler:^(NSDictionary *response){
        
        NSDictionary *result = [response objectForKey:@"result"];
        NSDictionary *current = [result objectForKey:@"current"];
        NSDictionary *b_customer = [current objectForKey:@"b_customer_count"];
        
        NSDictionary *summary = [b_customer objectForKey:type];
        NSNumber *member_total = [summary objectForKey:@"member"];
        NSNumber *walkin_total = [summary objectForKey:@"temp"];
        
        if(!member_total){
            member_total = [NSNumber numberWithInt:0];
        }
        
        if(!walkin_total){
            walkin_total = [NSNumber numberWithInt:0];
        }
        
        NSArray *details;
        if([type isEqualToString:@"day"]){
            details = [b_customer objectForKey:@"hours"];
        }else{
            details = [b_customer objectForKey:@"days"];
        }
        
        NSArray *filled = [self filledArray:details forType:type];// 填充数组缺失数据
        
        [self.reportDao batchInsertCustomerCount:filled type:type];
        
        [records removeAllObjects];
        
        for(NSDictionary *item in filled){
        
            NSNumber *member_count = [item objectForKey:@"member"];
            NSNumber *walkin_count = [item objectForKey:@"temp"];
            NSNumber *day = [item objectForKey:@"day"];
            NSNumber *hour = [item objectForKey:@"hour"];
            
            NSString *title;
            if([type isEqualToString:@"day"]){
                title = [NSString stringWithFormat:@"%d:00", [hour intValue]];
            }else{
                title = [NSString stringWithFormat:@"%d", [day intValue]];
            }
            
            CustomerCount *entity = [[CustomerCount alloc] initWithTotalMember:[member_total intValue] walkin:[walkin_total intValue] count:[member_count intValue] + [walkin_count intValue] title:title];
            
            [records addObject:entity];
        }
        
        [self resolveTop3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportCustomView *myView = (ReportCustomView*)self.view;
            [myView reload];
        });
    }];
}

-(NSArray*) filledArray:(NSArray*)origin forType:(NSString*)type
{
    NSMutableArray *filled = [NSMutableArray arrayWithCapacity:1];
    
    ReportDateStatus *status = [ReportDateStatus sharedInstance];
    int year = [status year];
    int month = [status month];
    int day = [status day];
    
    UserData *userData = [UserData load];
    NSString *currentEnterpriseId = userData.enterpriseId;
    
    for(int i = 0; i < [origin count]; i++){
        
        NSDictionary *item = [origin objectAtIndex:i];
        
        NSString *_id = [item objectForKey:@"_id"];
        
        if(![StringUtils isEmpty:_id]){
            [filled addObject:item];
            continue;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
       
        [dict setObject:[[NSUUID UUID] UUIDString] forKey:@"_id"];
        [dict setObject:currentEnterpriseId forKey:@"enterprise_id"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"member"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"temp"];
        [dict setObject:[NSNumber numberWithInt:year] forKey:@"year"];
        [dict setObject:[NSNumber numberWithInt:month] forKey:@"month"];
        
        if([type isEqualToString:@"day"]){
            [dict setObject:[NSNumber numberWithInt:day] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:i] forKey:@"hour"];
            NSTimeInterval time = [TimesHelper timeWithYear:year month:month day:day];
            [dict setObject:[NSNumber numberWithLongLong:time] forKey:@"create_date"];
        }else if([type isEqualToString:@"month"]){
            [dict setObject:[NSNumber numberWithInt:i + 1] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"hour"];
            NSTimeInterval time = [TimesHelper timeWithYear:year month:month day:i + 1];
            [dict setObject:[NSNumber numberWithLongLong:time] forKey:@"create_date"];
        }else{
            [dict setObject:[NSNumber numberWithInt:i + 1] forKey:@"day"];
            [dict setObject:[NSNumber numberWithInt:0] forKey:@"hour"];
            NSTimeInterval time = [TimesHelper timeWithYear:year month:month day:i + 1];
            [dict setObject:[NSNumber numberWithLongLong:time] forKey:@"create_date"];
        }
        
        [filled addObject:dict];
    }
    
    return filled;
}

-(void) resolveTop3
{
    [top3 removeAllObjects];
    
    NSArray *sorted = [records sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomerCount *entity1 = (CustomerCount*)obj1;
        CustomerCount *entity2 = (CustomerCount*)obj2;
        if(entity1.count < entity2.count){
            return NSOrderedDescending;
        }else if(entity1.count == entity2.count){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    int itemInTop3 = 0;
    
    for(int i = 0; i < [sorted count]; i++){
        
        if(itemInTop3 == 3){
            break;
        }
        
        CustomerCount *entity = [sorted objectAtIndex:i];
        
        if(i == 0){
            [top3 addObject:[NSNumber numberWithInt:entity.count]];
            itemInTop3 ++;
            continue;
        }
        
        CustomerCount *prev = [sorted objectAtIndex:i-1];
        if(entity.count != prev.count){
            [top3 addObject:[NSNumber numberWithInt:entity.count]];
            itemInTop3 ++;
        }
    }
}

#pragma mark - abstract method implementation

- (void) handleSwipeLeft
{
    [super handleSwipeLeft];
}

- (void) handleSwipeRight
{
    [super handleSwipeRight];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - customer view datasource

-(NSUInteger) memberCount
{
    CustomerCount *entity = [records firstObject];
    return entity.totalMember;
}

-(NSUInteger) walkinCount
{
    CustomerCount *entity = [records firstObject];
    return entity.totalWalkin;
}

#pragma mark - line chart datasource

-(NSUInteger) valuePerSection
{
    double max = 0.0;
    
    for(CustomerCount *entity in records){
        if(entity.count > max){
            max = entity.count;
        }
    }
    
    if(max < 5){
        return 1;
    }
    
    return ceil(max / 5);
}

-(NSUInteger) itemCount
{
    return [records count];
}

-(LosLineChartItem*) itemAtIndex:(int)index
{
    CustomerCount *entity = [records objectAtIndex:index];
    
    int order = 4;
    
    if(entity.count == [[top3 firstObject] intValue]){
        order = 1;
    }else if(entity.count == [[top3 objectAtIndex:1] intValue]){
        order = 2;
    }else if(entity.count == [[top3 objectAtIndex:2] intValue]){
        order = 3;
    }
    
    LosLineChartItem *item = [[LosLineChartItem alloc] initWithTitle:entity.title value:entity.count order:order];
    return item;
}

@end
