
#import "MoneyRecordViewController.h"

@interface MoneyRecordViewController (){
    NSInteger pageNo;
    NSMutableArray * recondArray;
}

@end

@implementation MoneyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包记录";
    pageNo = 1;
    recondArray = [NSMutableArray array];
    [self getMyMoneyRecondListData];
    
}
-(void)getMyMoneyRecondListData{
    GetRedpacket * packet = [[GetRedpacket alloc]init];
    packet.userId = [[UserDao sharedInstance]loadUser].userId ;
    packet.pageSize = 10;
    packet.pageNo = pageNo;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [packet excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        if ([responseDate[@"code"] isEqualToString:@"0"]) {
            NSArray * arr = responseDate[@"data"];
            if ([arr isEqual:[NSNull null]]) {
                WYEmptyTableFooterView * empty = [WYEmptyTableFooterView emptyTableFooterViewWithTableView:self.tableView];
                empty.placeholderLabel.text = @"挑战特殊任务轻松拿Here运动红包";
                self.tableView.tableFooterView = empty;
                return ;
            }
            for (id item in arr) {
                MyTredPacket * packet = [[MyTredPacket alloc]init];
                
                for (id key in [packet PropertyKeys]) {
                    [packet setValue:[item valueForKey:key] forKey:key];
                }
                [recondArray addObject:packet] ;
            }
            [self.tableView reloadData];
            
        }
        else{
            [Utile showPromptAlertWithString:@"请求出错"];
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error.description];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return recondArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"moneyCell";
    MoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    MyTredPacket * pack = [recondArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[MoneyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.moneyLabel.text = pack.amount;
    cell.dateLabel.text = [pack.date substringToIndex:10];
    cell.contednLabel.text = pack.bewrite;
    return cell;
}



@end
