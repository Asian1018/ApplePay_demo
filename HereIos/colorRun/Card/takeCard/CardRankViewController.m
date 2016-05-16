
#import "CardRankViewController.h"
#import "CardRankCell.h"
#import "PersonInfoViewController.h"
@interface CardRankViewController (){
   UILabel* ranklabel;
    UILabel * day;
    UIView *sectionView;
}
@property(nonatomic)NSInteger pageNo;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation CardRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打卡榜";
    self.pageNo = 1;
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [Utile showHereView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self requestDataWithPageNo:self.pageNo];
}
-(void)requestDataWithPageNo:(NSInteger)pageNo{
    CardRankingApi * api = [[CardRankingApi alloc]init];
    api.pageNo = pageNo;
    api.pageSize =10;
    api.cardId = self.cardId;
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        NSArray * cardList = jsonData[@"cardRankingList"];
        NSDictionary * userCard = jsonData[@"userCard"];
        UserCardModel * card = [UserCardModel initWithJSON:userCard];
        if (card.status == 1) {
            day.text = [NSString stringWithFormat:@"坚持 %ld 天",(long)card.days];
            NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile green]} ;
            NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:day.text];
            [changeText addAttributes:fontDict range:NSMakeRange(2,day.text.length - 3)] ;
            day.attributedText = changeText;
            if (card.sort.length > 0) {
                ranklabel.text = card.sort;
            }
        }
        
        if ([cardList isEqual:[NSNull null]]) {
            self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"您还没上版呢~~" image:nil];
            return ;
        }
        else{
            for (id item in cardList) {
                CardRankingList* card = [CardRankingList initWithJSON:item] ;
                [_dataArray addObject:card];
            }
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

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!sectionView) {
        sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 40)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel * line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.frame = CGRectMake(0, 39, VIEW_WIDTH, 0.5);
        [sectionView addSubview:line];
    }
    if (!ranklabel) {
        ranklabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 40)];
        ranklabel.text = @"未上榜";
        [sectionView addSubview:ranklabel];
    }
    if (!day) {
        day = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 90, 0, 80, 40)];
        day.text = @"坚持 0 天";
        NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile green]} ;
        NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:day.text];
        [changeText addAttributes:fontDict range:NSMakeRange(2,day.text.length - 3)] ;
        day.attributedText = changeText;
        [sectionView addSubview:day];
    }
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CardRankCell";
    CardRankingList* card = [self.dataArray objectAtIndex:indexPath.row];
    CardRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"CardRankCell" owner:self options:nil] lastObject];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell fillWithModel:card indexpath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CardRankingList* card = [self.dataArray objectAtIndex:indexPath.row];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = card.userId;
    [self.navigationController pushViewController:person animated:YES] ;

}
@end
