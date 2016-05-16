
#import "NotNotiViewController.h"
#import "NotifiCell.h"
#import "PersonInfoViewController.H"
@interface NotNotiViewController ()<NotifiCellDelegate>{

}
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation NotNotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [Utile showHereView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = view;
    _dataArray = [NSMutableArray array];
    [self getdata];
}
-(void)getdata{
    NotNotifi * noti = [[NotNotifi alloc]init];
    noti.userId = [[UserDao sharedInstance]loadUser].userId;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [noti executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        NSArray * arr = jsonData;
        if (arr.count > 0) {
            for (id team in jsonData) {
                GroupList * list = [GroupList initWithJSON:team];
                [_dataArray addObject:list];
            }
        }
        else{
            self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"没有未关注的逗比~" image:nil];
        }
        
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(void)notiWith:(NSInteger)followUserId cell:(NotifiCell *)cell{
    FollowApi * api = [[FollowApi alloc]init];
    api.followUserId = followUserId;
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
            //成功
            [cell.notiButton setBackgroundColor:[UIColor lightGrayColor]];
            cell.notiButton.enabled = NO;
            [Utile showWZHUDWithView:self.navigationController.view andString:@"get~已关注这货"];
            }
        else{
            //失败
            [Utile showPromptAlertWithString:@"关注失败,请稍后再试"];
        }
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellInder = @"NotifiCell";
    NotifiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInder];
    GroupList* list = [_dataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"NotifiCell" owner:self options:nil] lastObject];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell fillUIWith:list];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupList* list = [_dataArray objectAtIndex:indexPath.row];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = list.userId;
    [self.navigationController pushViewController:person animated:YES] ;


}

@end
