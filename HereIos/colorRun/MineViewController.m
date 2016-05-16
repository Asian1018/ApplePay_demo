
#import "MineViewController.h"
#import "UserDetailViewController.h"
#import "RDVTabBarController.h"
#import "LoginViewController.h"
#import "UserDao.h" 
#import "CoolApi.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MySportTableViewController.h"
#import "CompetitionTableViewController.h"
#import "NoLoginView.h"
#import "SystemSettingViewController.h"
#import "HealthManager.h"
#import "MyNewsViewController.h"
#import "MyGroupViewController.h"
#import "MyCardViewController.h"

@interface MineViewController ()<LoginDelegate>{
    UIView * foview;
}
@property (weak, nonatomic) IBOutlet UILabel *sportBadge;
@property (weak, nonatomic) IBOutlet UILabel *matchBadge;
@property (weak, nonatomic) IBOutlet UILabel *newsBadge;
@property (weak, nonatomic) IBOutlet UILabel *groupBadge;
@property (weak, nonatomic) IBOutlet UIButton *joinUsButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.periods.textColor = [Utile orange];
    self.kilometers.textColor = [Utile orange];
    self.focusValue.textColor = [Utile orange];
    self.joinUsButton.backgroundColor = [Utile green];
    self.sportBadge.hidden = YES;
    self.matchBadge.hidden = YES;
    self.groupBadge.hidden = YES;
    self.newsBadge.hidden = YES;
    foview = self.myFooterView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine ;
   
    self.tableView.delegate=self ;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2 ;
    self.avatar.clipsToBounds = YES;
    _dao = [UserDao sharedInstance];
    
    User* user =[_dao loadUser] ;
    if (user==nil ) {
        [self setStateWithWithoutLogin];
    }
}
/**
 *  没有登录状态下的headerView
 */
-(void)setLabelHiddenWith:(BOOL)bol {
    self.timeLabel.hidden = bol;
    self.mileLable.hidden = bol;
    self.kilometers.hidden = bol;
    self.periods.hidden = bol;
    self.nikeName.hidden = bol;
    self.createTime.hidden = bol;
    self.signe.hidden = bol;
    self.noLoginLabel.hidden = !bol;
    self.lineLabel.hidden = bol;
    self.focusPerson.hidden = bol ;
    self.focusValue.hidden=bol ;
}

-(void)setStateWithWithoutLogin{
    [_avatar setImage:[UIImage imageNamed:@"my_voucher"]] ;
    CGSize size = self.myHeagerView.frame.size;
    CGFloat height = 80;
    size.height = height;
    self.myHeagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.myHeagerView.frame), height);
    self.tableView.tableHeaderView = self.myHeagerView;
    [self setLabelHiddenWith:YES];

}
- (IBAction)showMyinfoOrLoginAction:(id)sender {
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UserDetailViewController *userDetail=[borad instantiateViewControllerWithIdentifier:@"userDetailViewController"] ;
    
    UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
  //  User* user =[[User sharedInstance]user] ;
    User* user =[[UserDao sharedInstance] loadUser] ;
    if (user != nil) {
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//        self.navigationItem.backBarButtonItem = barButtonItem;
        //                userDetail.user = user ;
        [self.navigationController pushViewController:userDetail animated:YES];
    }else{
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
    }
}

-(void)refreshViewInfo{
    User* user =[_dao loadUser] ;
    if (user!= nil ) {
        [self getUserInfo:user.userId]  ;
        self.tableView.tableFooterView = [UIView new];
    }
}
-(void)withoutLogin{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
//    loginController.delegate = self;
    [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
//    [self.navigationController pushViewController:loginController animated:YES] ;
}
//现在加入cool
- (IBAction)joinCoolNow:(id)sender {
    [self withoutLogin];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear") ;
    User* user =[_dao loadUser] ;
    NSLog(@"UserName=%@",user.nickName) ;
    if (user!=nil) {
         [self getUserInfo:user.userId] ;
    }
}

-(void) fillWithUser:(User*) user{
    self.noLoginLabel.hidden = YES;
    _nikeName.text=user.nickName ;
    _createTime.text=user.createTime ;
    _signe.text= user.signature;
    _kilometers.text=[NSString stringWithFormat:@"%lu",user.follow] ;
    _periods.text=[NSString stringWithFormat:@"%lu",user.cardCount] ;
    _focusValue.text=[NSString stringWithFormat:@"%lu",user.fans] ;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]] ;
    if (user.signature.length == 0) {
        _signe.text = @"个性签名不要隐藏着";
    }
    [self.tableView reloadData];
}
-(void) getUserInfo:(NSInteger) userId{
    GetUserInfo* getUserInfo = [[GetUserInfo alloc]init] ;
    getUserInfo.userId = userId ;
//    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [getUserInfo excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        NSLog(@"个人信息=%@",responseDate) ;
//        hud.hidden = YES;
        NSString* code = [responseDate valueForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary* data = [responseDate objectForKey:@"data"] ;
            User* user = [User initWithJSON:data] ;
           [_dao insert:user];
            if (user.remind.length > 1) {
                if ([user.remind rangeOfString:@"1"].location != NSNotFound) {
                    NSLog(@"这个字符串中有1");
                    self.matchBadge.hidden = NO;
                }
                if ([user.remind rangeOfString:@"2"].location != NSNotFound) {
                    NSLog(@"这个字符串中有2");
                    self.sportBadge.hidden = NO;
                }
                if ([user.remind rangeOfString:@"3"].location != NSNotFound) {
                    NSLog(@"这个字符串中有3");
                    self.groupBadge.hidden = NO;
                }
                if ([user.remind rangeOfString:@"4"].location != NSNotFound) {
                    NSLog(@"这个字符串中有4");
                    self.newsBadge.hidden = NO;
                }

            }
            [self fillWithUser:user] ;
//            NSLog(@"raw=%lu",raw) ;
        }

    } failure:^(NSURLSessionDataTask *response, NSError *error) {
         NSLog(@"fail=%@",error.description) ;
//        hud.hidden = YES;
    }];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView{
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//    [tableView setTableHeaderView:view];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UserDao sharedInstance]loadUser]==nil) {
        [self withoutLogin];
        return;
    }
    if (indexPath.row==5) {
       //消息通知
        MyNewsViewController * new = [[MyNewsViewController alloc]init];
        [self.navigationController pushViewController:new animated:YES];
         self.newsBadge.hidden = YES;
        
    }
    if (indexPath.row==3) {
        RewardTableViewController* rewardController = [[RewardTableViewController alloc]init] ;
        [self.navigationController pushViewController:rewardController animated:YES] ;
    }
    if (indexPath.row==0) {
        MySportTableViewController* sportTableView = [[MySportTableViewController alloc]init] ;
        [self.navigationController pushViewController:sportTableView animated:YES] ;
         self.sportBadge.hidden = YES;
    }
    if (indexPath.row==4) {
        //赛事卡劵
        CompetitionTableViewController* competition = [[CompetitionTableViewController alloc]init] ;
        [self.navigationController pushViewController:competition animated:YES] ;
        self.matchBadge.hidden = YES;
    }
    if (indexPath.row == 1) {
        //我的卡片
        MyCardViewController * card = [[MyCardViewController alloc]init];
        [self.navigationController pushViewController:card animated:YES];
    }
    if (indexPath.row == 2) {
        //我的圈子
        MyGroupViewController * group = [[MyGroupViewController alloc]init];
        [self.navigationController pushViewController:group animated:YES];
        self.groupBadge.hidden = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  //  User * user = [[User sharedInstance]user];
    User* user = [[UserDao sharedInstance] loadUser] ;
    if (user!=nil) {
        return 6;
    }
    return 6;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.lineLabel.backgroundColor = [UIColor clearColor];
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.lineLabel.frame.size.width, 0.5)];
    [self.lineLabel addSubview:la];
    la.backgroundColor = [UIColor lightGrayColor];
    
    [[self rdv_tabBarController] setTabBarHidden:NO] ;
    User *user = [[UserDao sharedInstance]loadUser];
    if (user!=nil) {
        [self setLabelHiddenWith:NO];
        [self fillWithUser:user];
        self.myHeagerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.myHeagerView.frame), 160);
        self.tableView.tableHeaderView = self.myHeagerView;
        self.tableView.tableFooterView = [UIView new];
        [self.tableView reloadData];
    }
    else{
        [self setStateWithWithoutLogin];
        self.tableView.tableFooterView = foview;
        [self.tableView reloadData];
    }
}

- (IBAction)showSettingAction:(id)sender {
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SystemSettingViewController *sys=[borad instantiateViewControllerWithIdentifier:@"SystemSettingViewController"] ;
    //        sys.manger = [HealthManager shareInstance];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    //        sys.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sys animated:YES];
}

@end
