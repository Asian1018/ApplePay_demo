
#import "PersonInfoViewController.h"
#import "RDVTabBarController.h"
#import "DVSwitch.h"
#import "MatchListViewController.h"
#import "BackGroundViewController.h"
#import "TotalMileViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "BurningModel.h"
#import "UserDetailViewController.h"
#import "LoginViewController.h"
@interface PersonInfoViewController ()<LoginDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    CGFloat margent;
    OtherPersonModel * model;

}
@property (weak, nonatomic) IBOutlet UIView *infoHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property(strong, nonatomic) TotalMileViewController * totalMileController;
@property(strong, nonatomic) MatchListViewController * matchViewController;
@property(strong, nonatomic) BackGroundViewController * backgroundViewController;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *downButton; //关注按钮
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardCountLabel;



@end

@implementation PersonInfoViewController
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 22) {
        if (buttonIndex == 1) {
            [Utile showWZHUDWithView:self.view andString:@"拉黑成功~"];
        }
    }
    


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击了----%ld",(long)buttonIndex);
    if (buttonIndex != 5) {
        [Utile showWZHUDWithView:self.view andString:@"投诉成功~"];
    }
    
    
    
    
    
}
- (IBAction)complainButtonClicked:(id)sender {
    NSLog(@"点击了投诉");
    UIAlertController * alView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * bAlert = [UIAlertAction actionWithTitle:@"加入黑名单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSLog(@"加入黑名单");
        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"将此人加入黑名单" message:@"你将不会再收到对方的评论和消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tag = 22;
        [al show];
        
    }];
    UIAlertAction * bAlert2 = [UIAlertAction actionWithTitle:@"投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"投诉");
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"欺诈", @"骚扰辱骂",@"发布情色或政治信息",@"活动或竞赛作弊",@"其他",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
    }];
    UIAlertAction * bAlert3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         NSLog(@"取消");
    }];
    
    [alView addAction:bAlert];
    [alView addAction:bAlert2];
    [alView addAction:bAlert3];
    [self presentViewController:alView animated:YES completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = YES;
     [self setNeedsStatusBarAppearanceUpdate];
    margent = 64;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.picImageView.layer.cornerRadius = self.picImageView.frame.size.height / 2;
    self.picImageView.clipsToBounds = YES;
    self.picImageView.layer.borderColor = [Utile green].CGColor;
    self.picImageView.layer.borderWidth = 2;
    self.title = @"";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.downButton.hidden = YES;
    [self getData];
}

-(void)getData{
    OtherPersonInfo * other = [[OtherPersonInfo alloc]init];
    other.userId = self.userId;
    if (self.userId != [[UserDao sharedInstance]loadUser].userId) {
        other.myUserId =[[UserDao sharedInstance]loadUser].userId;
    }
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [other excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        self.downButton.hidden = NO;
        hud.hidden = YES;
        NSLog(@"得到他人信息结果:%@",responseDate);
        NSString * code = responseDate[@"code"];
        if ([code isEqualToString:@"0"]) {
            //succ
            NSDictionary * dic = responseDate[@"data"];
            model = [[OtherPersonModel alloc]init];
            for (id key in [model PropertyKeys]) {
                [model setValue:[dic valueForKey:key] forKey:key] ;
            }
            [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"reward_come_on"]];
            if (model.nickName.length > 16) {
                model.nickName = [model.nickName substringToIndex:16];
            }
            self.nameLabel.text = model.nickName;
            if (model.signature.length > 0) {
                self.signLabel.text = model.signature;
            }
            if (model.sex == 2) {
                self.sexImageView.image = [UIImage imageNamed:@"sculpture_woman"];
            }
            else{
                self.sexImageView.image = [UIImage imageNamed:@"sculpture_man"];
            }
            if (model.relation == 1) {
                //已关注
                [self.downButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }

            self.followLabel.text = [NSString stringWithFormat:@"%ld",(long)model.follow];
            self.fansLabel.text = [NSString stringWithFormat:@"%ld",(long)model.fans];
            self.cardCountLabel.text = [NSString stringWithFormat:@"%ld",(long)model.cardCount];
            
            self.backgroundViewController = [[BackGroundViewController alloc]initWithKilometers:self.userId];
            self.backgroundViewController.view.frame = CGRectMake(0,CGRectGetMaxY(self.infoHeaderView.frame) , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.infoHeaderView.frame) - CGRectGetHeight(self.downButton.frame));
            if (model.relation < 0) {
                if (self.userId ==[[UserDao sharedInstance]loadUser].userId) {
                    self.downButton.hidden = YES;
                    self.backgroundViewController.view.frame = CGRectMake(0,CGRectGetMaxY(self.infoHeaderView.frame) , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.infoHeaderView.frame));
                }
            }
            [self.view addSubview:self.backgroundViewController.view];
            [self addChildViewController:self.backgroundViewController];
            
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        [Utile showPromptAlertWithString:error.description];
        hud.hidden = YES;
    }];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton * bu = [[UIButton alloc]initWithFrame:self.backView.frame];
    [bu setBackgroundColor:[UIColor clearColor]];
    [self.infoHeaderView addSubview:bu];
    [bu addTarget:self action:@selector(showPersonInfo) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showPersonInfo{
    if ([[UserDao sharedInstance]loadUser] == nil) {
        return;
    }
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UserDetailViewController *userDetail=[borad instantiateViewControllerWithIdentifier:@"userDetailViewController"] ;
    if (model) {
        userDetail.model = model;
    }
    userDetail.otherInfoType = @"1";
    [self.navigationController pushViewController:userDetail animated:YES];

}
- (IBAction)backToTopViewAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)refreshViewInfo{
    [self getData];

}
- (IBAction)downButtonClicked:(id)sender {
    if ([[UserDao sharedInstance]loadUser] == nil) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    
    if ([self.downButton.currentTitle isEqualToString:@"关注"]) {
        NSLog(@"关注用户");
        FollowApi * api = [[FollowApi alloc]init];
        api.userId = [[UserDao sharedInstance]loadUser].userId;
        api.followUserId = model.userId;
        MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
        [api executeHasParse:^(id jsonData) {
             hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                //成功;
                [self.downButton setTitle:@"取消关注" forState:UIControlStateNormal];
                
                [Utile showWZHUDWithView:self.navigationController.view andString:@"关注成功"];
            }
        } failure:^(NSString *error) {
            hud.hidden = YES;
            [Utile showPromptAlertWithString:error];
        }];
    }
    else if ([self.downButton.currentTitle isEqualToString:@"取消关注"]) {
        NSLog(@"取消关注用户");
        CancleFollow * api = [[CancleFollow alloc]init];
        api.userId = [[UserDao sharedInstance]loadUser].userId;
        api.followUserId = model.userId;
        MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
        [api executeHasParse:^(id jsonData) {
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                //成功;
                [self.downButton setTitle:@"关注" forState:UIControlStateNormal];
                [Utile showWZHUDWithView:self.navigationController.view andString:@"取消关注成功"];
            }
        } failure:^(NSString *error) {
            hud.hidden = YES;
            [Utile showPromptAlertWithString:error];
        }];
        
    }
    
}

@end
