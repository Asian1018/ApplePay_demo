
#import "HomeCardViewController.h"
#import "MyCardCell.h"
#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "DetailCardViewController.h"
#import "MorePersonsViewController.h"
#import "MoreCardsViewController.h"
#import "TakeCardViewController.h"
@interface HomeCardViewController ()<MyCardCellDelegate>

@property(nonatomic)NSInteger pageNo;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSNotificationCenter * center;
@end

@implementation HomeCardViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)heartBreakNotify:(NSNotificationCenter*)sender {
    self.tableView.tableFooterView = [Utile showHereView];
    self.dataArray = [NSMutableArray array];
    [self getCardData];
}
-(void)takeCardSuccess{
    self.pageNo = 1;
    [self getCardData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.center = [NSNotificationCenter defaultCenter];
    [self.center addObserver:self selector:@selector(heartBreakNotify:) name:REFRESH_MYCARD object:nil];
    [self.center addObserver:self selector:@selector(takeCardSuccess) name:TAKECARD_SUCCESS object:nil];
    self.title = @"卡片";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.pageNo = 1;
    self.dataArray = [NSMutableArray array];
//    [self creatEmptyFooterView];
    [self getCardData];
}

-(void) refreshData{
    self.pageNo = 1;
    self.tableView.tableFooterView = [Utile showHereView];
    [self getCardData];
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getCardData];

}
-(void)getCardData{
    
    User* user = [[UserDao sharedInstance]loadUser] ;
    if (!(user.userId > 0) ) {
        [self endFreshing];
        [self creatEmptyFooterView];
        [self.tableView reloadData];
        return;
    }
    GetUserCard * card = [[GetUserCard alloc]init];
    card.pageNo = self.pageNo;
    card.pageSize = 10;
    card.userId = user.userId ;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [card executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        [self endFreshing];
        if (self.pageNo == 1) {
            [_dataArray removeAllObjects];
            if ([jsonData isEqual:[NSNull null]]) {
                [self creatEmptyFooterView];
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
                    [_dataArray addObject:card];
                }
                if (_dataArray.count < 10) {
                    self.hasNext = NO ;
                }
                else{
                    self.hasNext = YES ;
                }
                [self.tableView reloadData];
            }
        }
        else{
        //加载更多
            if ([jsonData isEqual:[NSNull null]]) {
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
                    [_dataArray addObject:card];
                }
                if (_dataArray.count%10==0) {
                    self.hasNext=YES ;
                }else{
                    self.hasNext=NO ;
                }
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSString *error) {
        [self endFreshing];
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
}
//更多有趣的人
- (IBAction)moreInterestingPerson:(id)sender {
    MorePersonsViewController * person = [[MorePersonsViewController alloc]init];
    [self.navigationController pushViewController:person animated:YES];
    
}
//更多有趣的卡片
- (IBAction)moreCard:(id)sender {
    MoreCardsViewController* more = [[MoreCardsViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:more animated:YES];
    
}


- (IBAction)creatCardButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"creatCardIdent" sender:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO];
}

-(void)creatEmptyFooterView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    self.tableView.tableFooterView = view;
    UIView * cardView = [[UIView alloc]initWithFrame:CGRectMake(8, 4, view.frame.size.width - 8 * 2, 100 - 4 * 2)];
    cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cardView.layer.borderWidth = 1;
    cardView.layer.cornerRadius = 1;
    cardView.clipsToBounds = YES;
    cardView.backgroundColor = [UIColor whiteColor];
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_black_add"]];
    CGFloat w = cardView.frame.size.width / 2 - 50 / 2;
    image.frame = CGRectMake(w, 10, 50, 45);
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame) + 10, cardView.frame.size.width, 20)];
    la.text = @"Here, 开始有趣";
    la.font = [UIFont systemFontOfSize:18];
    la.textColor = [UIColor lightGrayColor];
    la.textAlignment = NSTextAlignmentCenter;
    [cardView addSubview:la];
    
    [cardView addSubview:image];
    UIButton * bu = [[UIButton alloc]initWithFrame:cardView.frame];
//    bu.backgroundColor = [UIColor redColor];
    [bu addTarget:self action:@selector(creatCard) forControlEvents:UIControlEventTouchUpInside];
    [cardView addSubview:bu];
    
    [view addSubview:cardView];
    
}
-(void)creatCard{
    NSLog(@"点击");
    [self performSegueWithIdentifier:@"creatCardIdent" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma MyCardCellDelegate
-(void)signCardAction:(MyCardCell *)cell{
    NSLog(@"点击了打卡按钮:%ld",cell.titleLabel.tag);
//    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"TakeCard" bundle:[NSBundle mainBundle]];
//    TakeCardViewController *takeCard =[borad instantiateViewControllerWithIdentifier:NSStringFromClass([TakeCardViewController class])] ;
//    MyCardListModel* cards = [_dataArray objectAtIndex:cell.titleLabel.tag];
//    CardShareData * data = [[CardShareData alloc]init];
//    data.qcId = cards.qcId;
//    data.userId = [[UserDao sharedInstance]loadUser].userId;
//    data.cardId = cards.cardId;
//    data.title = cards.title;
//    data.target = cards.target;
//    data.targetValue = cards.targetValue;
//    takeCard.takeCardApi = data;
//    takeCard.cardType = cards.cardType;
//    takeCard.userDays = cards.days;
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:takeCard];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indent = @"MyCardCell";
    //自定义cell类
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    MyCardListModel* card = [_dataArray objectAtIndex:indexPath.row];
    MyCardCell * cell = [tableView dequeueReusableCellWithIdentifier:indent];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MycardCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        cell.titleLabel.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    [cell fillCellWithModel:card];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 150, 30)];
    la.font = [UIFont systemFontOfSize:15];
    la.textColor = [UIColor grayColor];
    la.textAlignment = NSTextAlignmentLeft;
    la.text = @"  我的卡片  ";
    [view addSubview:la];
    UILabel * lable = [[UILabel alloc]init];
    lable.backgroundColor = [UIColor lightGrayColor];
    lable.frame = CGRectMake(0, 39, view.frame.size.width, 0.5);
    [view addSubview:lable];
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    line.frame = CGRectMake(0, 0, view.frame.size.width, 10);
    [view addSubview:line];
    return view;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld个cell",(long)indexPath.row);
    MyCardListModel* card = [_dataArray objectAtIndex:indexPath.row];
    DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
    de.cardId = card.cardId;
    de.cardType = card.cardType;
    [self.navigationController pushViewController:de animated:YES];

}

@end
