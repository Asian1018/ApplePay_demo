
#import "InteractCell.h"
#import "InteractListViewController.h"
#import "DetailCardViewController.h"
#import "InteractrelationTableViewController.h"
@interface InteractListViewController ()
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation InteractListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    self.pageNo = 1;
    [self getdata];
    
}
-(void) refreshData{
    self.pageNo = 1;
    [self getdata] ;
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getdata] ;
}
-(void)getdata{
    
    InteractListApi * api = [[InteractListApi alloc]init];
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    api.pageNo = self.pageNo;
    api.pageSize = 10;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        [self endFreshing];
        if (self.pageNo == 1) {
            [_dataArray removeAllObjects];
            NSArray * arr = jsonData;
            if (arr.count > 0) {
                for (id team in arr) {
                    InteractList * list = [InteractList initWithJSON:team];
                    [_dataArray addObject:list];
                }
                if (_dataArray.count < 10) {
                    self.hasNext = NO;
                }
                else{
                    self.hasNext = YES;
                }
                [self.tableView reloadData];
            }
            else{
                self.hasNext = NO;
                self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"这里空空如也~~" image:[UIImage imageNamed:@"not_one"]];
            }
        }
        else{
            NSArray * arr = jsonData;
            if (arr.count > 0) {
                for (id team in arr) {
                    InteractList * list = [InteractList initWithJSON:team];
                    [_dataArray addObject:list];
                }
                if (_dataArray.count %10 == 0) {
                    self.hasNext = YES ;
                }else{
                    self.hasNext = NO ;
                }
                [self.tableView reloadData] ;
            }
            else{
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                self.hasNext = NO;
            }
        
        }
        
    } failure:^(NSString *error) {
         hud.hidden = YES;
        [self endFreshing];
        [Utile showPromptAlertWithString:error];
    }];
    
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellindent = @"InteractCell";
    
    InteractCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindent];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InteractCell" owner:self options:nil] lastObject];
    }
    InteractList * list = [_dataArray objectAtIndex:indexPath.row];
    [cell fillUIWith:list];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractList * list = [_dataArray objectAtIndex:indexPath.row];
    //1: 赞 2: 加入卡片 3: 邀请卡片 4: 分享
    switch (list.type) {
        case 1:{
            InteractrelationTableViewController * inter = [[InteractrelationTableViewController alloc]init];
            inter.mid = list.mId;
            inter.title = @"赞的用户";
            [self.navigationController pushViewController:inter animated:YES];
        }
            break;
        case 2:{
            InteractrelationTableViewController * inter = [[InteractrelationTableViewController alloc]init];
            inter.mid = list.mId;
            inter.title = @"加入卡片的用户";
            [self.navigationController pushViewController:inter animated:YES];
        }
            
            break;
        case 3:{
            DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
            de.cardId = list.commonId;
            de.cardType = list.commonType;
            de.fromType = @"22";
            [self.navigationController pushViewController:de animated:YES];
        }
            break;
        case 4:
            
            break;
            
        default:
            break;
    }
    
    
    
}
@end
