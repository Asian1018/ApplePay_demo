
#import "MyGroupViewController.h"
#import "RDVTabBarController.h"
#import "ChineseString.h"
#import "UIImageView+WebCache.h"
#import "MyGroupCell.h"
#import "NotNotiViewController.h"
#import "PersonInfoViewController.h"
@interface MyGroupViewController ()
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray * chooseArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *LetterResultArr;
@property(nonatomic,retain)NSMutableArray *personIdArray;


@end

@implementation MyGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的圈子";
    self.tableView.tableFooterView = [Utile showHereView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _dataArray = [NSMutableArray array];
    _personIdArray = [NSMutableArray array];
    self.chooseArray = [NSMutableArray array];
    [self getData];
    
}
-(void)getData{
    GroupListApi * api = [[GroupListApi alloc]init];
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [api executeHasParse:^(id jsonData) {
        [self drawHeaderView];
        hud.hidden = YES;
        NSLog(@"得到的数组结果:%@",jsonData);
        NSMutableArray * personArray = [NSMutableArray array];
        for (id item in jsonData) {
            GroupList * list = [GroupList initWithJSON:item];
            [_dataArray addObject:list];
            [_personIdArray addObject:[NSString stringWithFormat:@"%ld",(long)list.userId]];
            [personArray addObject:list.nickName];
            _indexArray = [ChineseString IndexArray:personArray];
            _LetterResultArr = [ChineseString LetterSortArray:personArray];
        }
        [self.tableView reloadData];
        
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
}

-(void)drawHeaderView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, VIEW_WIDTH, 52);
    UIImageView * im = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 36, 36)];
    im.image = [UIImage imageNamed:@"my_circle_concern"];
    [view addSubview:im];
    UILabel * la = [[UILabel alloc]init];
    la.frame = CGRectMake(52 + 2 , 16 , 100, 20);
//    la.center = im.center;
//    la.backgroundColor = [UIColor redColor];
    la.text = @"新的逗比";
    [view addSubview:la];
    UIButton * bu = [[UIButton alloc]initWithFrame:view.frame];
    [bu addTarget:self action:@selector(showNotNoti) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bu];
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, 51, VIEW_WIDTH, 0.5);
    [view addSubview:line];
    self.tableView.tableHeaderView = view;
}
-(void)showNotNoti{
    NSLog(@"未关注的");
    NotNotiViewController * noti = [[NotNotiViewController alloc]init];
    noti.title = @"未关注的逗比";
    [self.navigationController pushViewController:noti animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;
    
}
#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.LetterResultArr objectAtIndex:section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [_indexArray objectAtIndex:section];
    return key;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 20)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 100, 20)];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lab.text = [_indexArray objectAtIndex:section];
    lab.textColor = [UIColor blackColor];
    [view addSubview:lab];
    return view;
}

#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //    NSLog(@"title===%@",title);
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellInd = @"MyGroupCell";
    MyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    GroupList * list = [[GroupList alloc]init];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyGroupCell" owner:self options:nil] lastObject];
    }
    //    cell.nameLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (GroupList * lists in _dataArray) {
        if ([lists.nickName isEqualToString:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]) {
            list = lists;
            break;
        }
    }
    cell.name.text = list.nickName;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
//    cell.imageView.image = [UIImage imageNamed:@"card_bg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
        GroupList * list = [[GroupList alloc]init];
        for (GroupList * lists in _dataArray) {
            if ([lists.nickName isEqualToString:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]) {
                list = lists;
                break;
            }
        }
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = list.userId;
    [self.navigationController pushViewController:person animated:YES] ;

}
@end
