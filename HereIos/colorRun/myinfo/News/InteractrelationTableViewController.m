
#import "InteractrelationTableViewController.h"
#import "NotifiCell.h"
#import "PersonInfoViewController.h"
@interface InteractrelationTableViewController ()<NotifiCellDelegate>
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation InteractrelationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [Utile showHereView];
    _dataArray = [NSMutableArray array];
    [self getdata];
}
-(void)getdata{
    InteractrelationApi* api = [[InteractrelationApi alloc]init];
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    api.pageNo = 1;
    api.pageSize = 10;
    api.mId = self.mid;
     MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        NSArray * arr = jsonData;
        if (arr.count > 0) {
            for (id team in jsonData) {
                InteractRelation * list = [InteractRelation initWithJSON:team];
                NSLog(@"关注类型:%ld",(long)list.relation);
                [_dataArray addObject:list];
            }
        }
        else{
            self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"没有取到相关的逗比~" image:nil];
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
            for (int i = 0 ;i < self.dataArray.count;i++) {
                InteractRelation * inter = [_dataArray objectAtIndex:i];
                if (inter.userId == followUserId) {
                    inter.relation = 1;
                    break;
                }
            }
            [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellInder = @"NotifiCell";
    NotifiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInder];
    InteractRelation * inter = [_dataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NotifiCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    GroupList *list = [[GroupList alloc]init];
    list.nickName = inter.nickName;
    list.avatar = inter.avatar;
    list.userId = inter.userId;
    [cell fillUIWith:list relation:inter.relation];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InteractRelation * inter = [_dataArray objectAtIndex:indexPath.row];
    
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = inter.userId;
    [self.navigationController pushViewController:person animated:YES] ;

}

@end
