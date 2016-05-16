//
//  MySportTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "MySportTableViewController.h"
#import "MySportTableViewCell.h"
#import "Utile.h"
#import "MyModel.h"
#import "RDVTabBarController.h"
#import "MBProgressHUD.h"
#import "SportContrailViewController.h"
@interface MySportTableViewController ()

@end

@implementation MySportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone ;
    _dataDict = [NSMutableDictionary dictionary] ;
    _groupArray=[NSMutableArray array] ;
    
    self.navigationItem.title=@"我的运动";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor] ;
//    self.navigationController.navigationItem.leftBarButtonItem.title=@"" ;
    [self loadData:1] ;
}

-(void) refreshData{
    [self loadData:1] ;
}

-(void) loadNext{
    NSInteger currentPage = _getRecordListApi.pageNo ;
    [self loadData:currentPage+1] ;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES]  ;
}
-(void) loadData:(NSInteger) page{
    NSString * contentString = @"您暂时还没参加过运动呢~~~";
   _getRecordListApi = [[Getrecordlist alloc]init] ;
    User* user = [[UserDao sharedInstance]loadUser] ;
//    User *user = [[User sharedInstance] user];
    _getRecordListApi.userId = user.userId ;
    _getRecordListApi.pageNo = page ;
   MBProgressHUD* hud =  [Utile showHudInView:self.navigationController.view];
    [_getRecordListApi excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        NSString* code = [responseDate valueForKey:@"code"] ;
        [self endFreshing];
        if ([code isEqualToString:@"0"]) {
            NSArray* sportArray= [NSMutableArray array] ;
            NSArray* data= [responseDate objectForKey:@"data"] ;
            if (![data isEqual:[NSNull null]]) {
                if (page==1) {
                    if (_groupArray.count > 0) {
                        [_groupArray removeAllObjects] ;
                    }
//                    self.dataDict = [NSMutableDictionary dictionary];
                    if (self.dataDict.count > 0) {
                        [self.dataDict removeAllObjects];
                    }
                }
                for (id item in data) {
                    MySport* sport = [[MySport alloc]init] ;
                    for (id key in [sport PropertyKeys]) {
                        [sport setValue:[item valueForKey:key] forKey:key];
                    }
                    sportArray=[sportArray arrayByAddingObject:sport] ;
                }
                for (MySport* sport in sportArray) {
                    NSInteger year =[Utile getYear:[sport.runTime longLongValue]] ;
                    NSInteger month=[Utile getMonth:[sport.runTime longLongValue]] ;
                    NSString* key = [NSString stringWithFormat:@"%lu年%lu月",year,month] ;
                    NSArray* itemArray=[_dataDict objectForKey:key] ;
                    if (itemArray) {
                        itemArray=[itemArray arrayByAddingObject:sport] ;
                        [_dataDict setValue:itemArray forKey:key] ;//这一行代码非常重要
                    }else{
                        itemArray=[NSMutableArray array];
                        itemArray=[itemArray arrayByAddingObject:sport] ;
                        [_dataDict setValue:itemArray forKey:key] ;
                        [_groupArray addObject:key] ;
                    }
                }
//                [self loadEndWithContent:contentString imageName:nil] ;
                [self.tableView reloadData] ;
                if (sportArray.count%10==0) {
                    self.hasNext=YES ;
                }else{
                    self.hasNext=NO ;
                }
                [self.tableView reloadData] ;
            }
            else{
                self.hasNext=NO ;
                [self loadEndWithContent:contentString imageName:nil] ;
            }
           
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        hud.hidden = YES;
        [self showErrorAlertWithString:@"系统出错,请稍后再试~~"];
        [self endFreshing];
    }];
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   /* if(!_loadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
        
    {
        
       // [self loadDataBegin];
        
    }*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    NSLog(@"section=%lu",_groupArray.count) ;
    return _groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSString* key = [_groupArray objectAtIndex:section] ;
    NSArray* array=[_dataDict objectForKey:key] ;
    return array.count;
}

//-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [_groupArray objectAtIndex:section] ;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* key = [_groupArray objectAtIndex:indexPath.section] ;
    MySport* sport =[[_dataDict objectForKey:key] objectAtIndex:indexPath.row] ;
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"my_sport";
    //自定义cell类
    MySportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MySportCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell fillUiWithMode:sport] ;
    return cell;

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
    headerLabel.text = key;
    NSString * yearString = [key substringToIndex:4];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString * nowYear = [dateString substringToIndex:4];
    if ([yearString isEqualToString:nowYear]) {
        //当年的只显示月份
        headerLabel.text = [key substringWithRange:NSMakeRange(5, key.length - 5)];
    }
    
    UILabel* kilomiterLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width-100, 10, 100, 20)] ;
    kilomiterLabel.font=  font;
    // MySport* sport = [[_dataDict objectForKey:key]objectAtIndex:0] ;
    NSArray* array = [_dataDict objectForKey:key] ;
    MySport* sport = [array objectAtIndex:0] ;
    kilomiterLabel.textColor = [Utile green];
    kilomiterLabel.text=[NSString stringWithFormat:@"%.2f 公里",sport.monthMeters];
    [headerView addSubview:kilomiterLabel] ;
    [headerView addSubview:headerLabel];
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.tableView.frame.size.width, 0.5)];
    [headerView addSubview:lineLabel];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    return headerView ;
}

-(void)getSportHistoryData:(MySport*)sport{
    MBProgressHUD* hud = [Utile showHudInView:self.navigationController.view];
    User * user = [[UserDao sharedInstance]loadUser];
    GetSportHistory * history = [[GetSportHistory alloc]init];
    history.userId = user.userId ;
    history.recordId = sport.recordId;
    [history excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        if ([responseDate[@"code"] isEqualToString:@"0"]) {
            NSDictionary * dic = responseDate[@"data"];
            SportHistory* SportHy = [[SportHistory alloc]init];
            for (id key in [SportHy PropertyKeys]) {
                [SportHy setValue:[dic objectForKey:key] forKey:key];
            }
            NSArray * array = [Utile changJsonStringToObject:SportHy.data];
            NSMutableArray * lastArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i++) {
                NSDictionary * dictionary = array[i];
                JsobStringModel * json = [[JsobStringModel alloc]init];
                for (id key in [json PropertyKeys]) {
                    [json setValue:[dictionary objectForKey:key] forKey:key];
                    
                }
                CLLocation * locat = [[CLLocation alloc]initWithLatitude:json.latitude longitude:json.longitude];
                [lastArray addObject:locat];
            }
            
            BurningModel * model = [[BurningModel alloc]init];
            model.pace = SportHy.pace;
            model.startDate = [NSDate dateWithTimeIntervalSince1970:SportHy.startTime];
            model.endDate = [NSDate dateWithTimeIntervalSince1970:SportHy.endTime];
            model.totalMeter = SportHy.meter;
            model.avgPace = SportHy.avgPace;
            model.maxPace = SportHy.maxPace;
            model.minPace = SportHy.minPace;
            model.lastDate = [NSDate dateWithTimeIntervalSince1970:SportHy.endTime];
            model.startDate = [NSDate dateWithTimeIntervalSince1970:SportHy.startTime];
            UIStoryboard *borad = [UIStoryboard storyboardWithName:@"SportResult" bundle:[NSBundle mainBundle]];
            SportContrailViewController * sports=[borad instantiateViewControllerWithIdentifier:NSStringFromClass([SportContrailViewController class])] ;
            sports.locatArray = lastArray;
            if (lastArray.count < 2) {
                [Utile showPromptAlertWithString:@"该记录数据有误"];
                return ;
            }
            sports.burnModel = model;
            sports.fromType = @"1";
            sports.recordId = sport.recordId;
            sports.shareUrl = SportHy.shareUrl;
            [self.navigationController pushViewController:sports animated:YES] ;
            
        }
        
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        [Utile showPromptAlertWithString:error.description];
        hud.hidden = YES;
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* key = [_groupArray objectAtIndex:indexPath.section] ;
    MySport* sport =[[_dataDict objectForKey:key] objectAtIndex:indexPath.row] ;
    [self getSportHistoryData:sport];

}

@end
