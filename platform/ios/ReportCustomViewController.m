#import "ReportCustomViewController.h"
#import "ReportCustomView.h"
#import "UserData.h"
#import "StringUtils.h"
#import "ReportDateStatus.h"
#import "CustomerCount.h"

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
        
        NSArray *details;
        if([type isEqualToString:@"day"]){
            details = [b_customer objectForKey:@"hours"];
        }else{
            details = [b_customer objectForKey:@"days"];
        }
        
        [self.reportDao batchInsertCustomerCount:details type:type];
        
        [records removeAllObjects];
        
        for(NSDictionary *item in details){
            
            NSNumber *member_count = [item objectForKey:@"member"];
            NSNumber *walkin_count = [item objectForKey:@"temp"];
            NSNumber *day = [item objectForKey:@"day"];
            NSNumber *hour = [item objectForKey:@"hour"];
            
            CustomerCount *entity;
            
            if([type isEqualToString:@"day"]){
                NSString *title = [NSString stringWithFormat:@"%d:00", [hour intValue]];
                entity = [[CustomerCount alloc] initWithTotalMember:[member_total intValue] walkin:[walkin_total intValue] count:[member_count intValue] + [walkin_count intValue] title:title];
            }else{
                NSString *title = [NSString stringWithFormat:@"%d", [day intValue]];
                entity = [[CustomerCount alloc] initWithTotalMember:[member_total intValue] walkin:[walkin_total intValue] count:[member_count intValue] + [walkin_count intValue] title:title];
            }
    
            [records addObject:entity];
        }
        
        [self resolveTop3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ReportCustomView *myView = (ReportCustomView*)self.view;
            [myView reload];
        });
    }];
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

        CustomerCount *entity = [records objectAtIndex:i];
        
        if(i == 0){
            [top3 addObject:[NSNumber numberWithInt:entity.count]];
            itemInTop3 ++;
            return;
        }
        
        if(itemInTop3 == 3){
            return;
        }
        
        CustomerCount *prev = [records objectAtIndex:i-1];
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
