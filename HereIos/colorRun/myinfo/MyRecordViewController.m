
#import "MyRecordViewController.h"
#import "MySportTableViewCell.h"

@interface MyRecordViewController ()
@property(nonatomic,strong) NSMutableDictionary *dataDict ;
@property(nonatomic,strong) NSMutableArray* groupArray ;
@property(nonatomic,strong)  ActivityRecord * record;
@end

@implementation MyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupArray = [NSMutableArray array];
    self.dataDict = [NSMutableDictionary dictionary];
    // Do any additional setup after loading the view.
    [self loadDataWithPage:1];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"我的战绩";
}

-(void)loadDataWithPage:(NSInteger)page{
    _record = [[ActivityRecord alloc]init];
    _record.pageNo = page;
    _record.pageSize = self.size;
    _record.oaId = self.oaId;
    _record.userId = [[UserDao sharedInstance]loadUser].userId ;
    [_record excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        if ([responseDate[@"code"] isEqualToString:@"0"]) {
            NSArray * arr = responseDate[@"data"];
            NSMutableArray* recordArray= [NSMutableArray array] ;
            if ([arr isEqual:[NSNull null]]) {
                WYEmptyTableFooterView * empty = [WYEmptyTableFooterView emptyTableFooterViewWithTableView:self.tableView];
                empty.placeholderLabel.text = @"还没挑战任务呢~~";
                self.tableView.tableFooterView = empty;
                return ;
            }
            for (id item in arr) {
                MyRecond* record = [[MyRecond alloc]init] ;
                for (id key in [record PropertyKeys]) {
                    [record setValue:[item valueForKey:key] forKey:key];
                }
                [recordArray addObject:record];
            }
            for (MyRecond* record in recordArray) {
                NSInteger year =[Utile getYear:record.runTime] ;
                NSInteger month=[Utile getMonth:record.runTime] ;
                NSString* key = [NSString stringWithFormat:@"%lu年%lu月",year,month] ;
                if (month < 10) {
                    key = [NSString stringWithFormat:@"%lu年%0lu月",year,month] ;
                }
                NSArray* itemArray=[_dataDict objectForKey:key] ;
                if (itemArray) {
                    itemArray=[itemArray arrayByAddingObject:record] ;
                    [_dataDict setValue:itemArray forKey:key] ;
                }else{
                    itemArray=[NSMutableArray array];
                    itemArray=[itemArray arrayByAddingObject:record] ;
                    [_dataDict setValue:itemArray forKey:key] ;
                    [_groupArray addObject:key] ;
                }
            }
            [self.tableView reloadData];
        }
        
        else{
            [Utile showPromptAlertWithString:@"请求出错"];
        }
        
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        
        
        
    }];

}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0 ;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0 ;
}
//-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"活动奖励" ;
//}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIFont * font = [UIFont systemFontOfSize:16];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];//创建一个视图
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerLabel.font = font;
    headerLabel.textColor = [Utile colorWithHex:0x2f2f2f alpha:1];
    NSString* key = [_groupArray objectAtIndex:section] ;
    NSString * yearString = [key substringToIndex:4];
    headerLabel.text = key;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * nowYear = [dateString substringToIndex:4];
    if ([yearString isEqualToString:nowYear]) {
        //当年的只显示月份
        headerLabel.text = [key substringWithRange:NSMakeRange(5, key.length - 5)];
    }
    
    UILabel* kilomiterLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-160, 10, 150, 20)] ;
    kilomiterLabel.font=  font;
    NSArray * arr = [_dataDict valueForKey:key];
    MyRecond* record = arr.firstObject ;
    kilomiterLabel.textColor = [Utile green];
    kilomiterLabel.textAlignment = NSTextAlignmentRight;
    kilomiterLabel.text=[NSString stringWithFormat:@"挑战该任务%lu次",record.count];
    [headerView addSubview:kilomiterLabel] ;
    [headerView addSubview:headerLabel];
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.tableView.frame.size.width, 0.5)];
    [headerView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    
    return headerView ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //    NSLog(@"section=%lu",_groupArray.count) ;
    return _groupArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSString* key = [_groupArray objectAtIndex:section] ;
    NSArray* array=[_dataDict objectForKey:key] ;
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key = [_groupArray objectAtIndex:indexPath.section] ;
    MyRecond* record =[[_dataDict objectForKey:key] objectAtIndex:indexPath.row] ;
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"my_sport";
    //自定义cell类
    MySportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MySportCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.kilometer.text=[NSString stringWithFormat:@"%@  公里",record.kilometer] ;
    cell.pace.text=[NSString stringWithFormat:@"%@/km",record.pace] ;
    cell.period.text=record.period ;
    if (record.sportMode==0) {//走路
        UIImage* image=[UIImage imageNamed:@"my_walk"] ;
        cell.runType.image=image ;
    }else{
        UIImage* image=[UIImage imageNamed:@"my_run"] ;
        cell.runType.image = image ;
    }
//    if (record.sportMode==0) {
//        cell.activityType.hidden=YES ;
//    }else{
        cell.activityType.hidden = YES ;
//    }
    
    NSInteger day = [Utile getDay:record.runTime] ;
    NSString* timeDesc = [Utile getTimeDesc:record.runTime] ;
    cell.time.text=[NSString stringWithFormat:@"%lu日%@",day,timeDesc] ;
    
    
    return cell;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
