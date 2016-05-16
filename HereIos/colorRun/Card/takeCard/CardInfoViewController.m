
#import "CardInfoViewController.h"
#import "TimePickerViewController.h"
#import "InviteFriendsViewController.h"
@interface CardInfoViewController ()<TimePickerViewControllerDelegate,InviteFriendsViewControllerDelegate>{
    UIButton* downButton;
    BOOL showQuick;
    NSInteger inviCount;
}
@property (weak, nonatomic) IBOutlet UILabel *sportTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateroryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cateDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *broadcastButton;
@property (weak, nonatomic) IBOutlet UIButton *unBroadcastButton;
@property (weak, nonatomic) IBOutlet UILabel *prizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peizeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteCount;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) CardDetailModel * model;

@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *inviteFriendCell;


@end

@implementation CardInfoViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, VIEW_WIDTH, 100);
    CGFloat heigth = [UIScreen mainScreen].applicationFrame.size.height - CGRectGetMaxY(self.timeCell.frame) - 44;
    NSLog(@"高度:%f",heigth);
    if (heigth > 100) {
        CGRect frame = view.frame;
        frame.size.height = heigth;
        view.frame = frame;
    }
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    downButton = [[UIButton alloc]init];
    [downButton setBackgroundColor:[Utile green]];
    [downButton setTitle:@"退出卡片" forState:UIControlStateNormal];
    downButton.frame = CGRectMake(0, CGRectGetHeight(view.frame) - 50, VIEW_WIDTH, 50);
    downButton.tintColor = [UIColor whiteColor];
    [downButton addTarget:self action:@selector(lastButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:downButton];
    self.tableView.tableFooterView = view;
}

-(void)lastButtonClicked{
    if (showQuick) {
        QuickCard * quick = [[QuickCard alloc]init];
        quick.qcId = self.model.qcId;
        MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
        [quick executeHasParse:^(id jsonData) {
            hud.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                //退出成功
                [Utile showWZHUDWithView:self.navigationController.view andString:@"退出成功"];
                [downButton setTitle:@"加入卡片" forState:UIControlStateNormal];
                showQuick = NO;
                [self.navigationController popViewControllerAnimated:YES];
                if ([self.delagate respondsToSelector:@selector(logoutAction)]) {
                    [self.delagate logoutAction];
                }
            }
            else{
                [Utile showPromptAlertWithString:@"退出失败"];
            }
        } failure:^(NSString *error) {
            hud.hidden = YES;
            [Utile showPromptAlertWithString:error];
        }];
    }
    else{
        //加入卡片
        AddCard * add = [[AddCard alloc]init];
        add.userId = [[UserDao sharedInstance]loadUser].userId;
        add.cardId = self.cardId;
         MBProgressHUD * huds = [Utile showHudInView:self.navigationController.view];
        [add executeHasParse:^(id jsonData) {
            huds.hidden = YES;
            if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                //退出成功
               [Utile showWZHUDWithView:self.navigationController.view andString:@"加入成功"];
                [downButton setTitle:@"退出卡片" forState:UIControlStateNormal];
                showQuick = YES;
                self.model.qcId =[[NSString stringWithFormat:@"%@",jsonData[@"qcId"]] integerValue];
            }
            else{
                [Utile showPromptAlertWithString:@"加入失败"];
            }
            
        } failure:^(NSString *error) {
            huds.hidden = YES;
            [Utile showPromptAlertWithString:error];
        }];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    inviCount = 0;
    showQuick = YES;
    self.title = @"卡片详情";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self getData];

}
-(void)fillContentWith:(CardDetailModel*)detail{
    if (detail.cardMode == 1) {
        self.sportTypeLabel.text = @"生活也要玩";
    }
    else{
        self.sportTypeLabel.text = @"运动要目标";
    }
    switch (detail.cardType) {
        case 0:{
            self.cateroryLabel.text = @"快捷";
            self.cateDesLabel.text = @"打卡时不要求上传图片";
        }
            break;
        case 1:{
            self.cateroryLabel.text = @"图片";
            self.cateDesLabel.text = @"打卡时要求上传图片";
            
        }
            break;
        case 2:{
            self.cateroryLabel.text = @"计步";
            self.cateDesLabel.text = @"打卡时要使用计步工具或功能";
            
        }
            break;
        case 3:{
            self.cateroryLabel.text = @"跑步";
            self.cateDesLabel.text = @"打卡时要使用跑步工具或功能";
            
        }
            break;
            
        default:
            break;
    }
    if (detail.target ==1) {
        //计步
        self.stepCountLabel.text = [NSString stringWithFormat:@"%ld步",(long)detail.targetValue];
    }
    else if (detail.target == 2){
        //跑步
        self.stepCountLabel.text = [NSString stringWithFormat:@"%ld米",(long)detail.targetValue];
    }
    //创建者
    if (detail.createCard == 0) {
        if (detail.broadcast == 0) {
            [self.broadcastButton setImage:[UIImage imageNamed:@"choice_press"] forState:UIControlStateNormal];
        }
        else if (detail.broadcast == 1){
            [self.unBroadcastButton setImage:[UIImage imageNamed:@"choice_press"] forState:UIControlStateNormal];
        }
    }
    if (detail.isReward) {
        //有奖品
        self.prizeLabel.text = detail.prizeName;
        self.peizeContentLabel.text = detail.prizeDetail;
    }
    self.cardContentLabel.text = detail.bewrite;
    self.joinCountLabel.text = [NSString stringWithFormat:@"%ld",(long)detail.joinCount];
//    self.inviteCount.text = [NSString stringWithFormat:@"%ld",(long)detail.userCount];
    self.inviteCount.text = [NSString stringWithFormat:@"叫来 %ld 个逗比",(long)detail.userCount];
    inviCount = detail.userCount;
    self.timeLabel.text =[self getTimeString:detail.remindTime];
    
    [self.tableView reloadData];
    
}

-(NSString *)getTimeString:(NSInteger)count{
    NSString * lastStr = @"";
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",count/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(count%3600)/60];

    lastStr = [NSString stringWithFormat:@"%@:%@",str_hour,str_minute];
    if ([lastStr isEqualToString:@"00:00"]) {
        lastStr = @"19:00";
    }
    return lastStr;
}
-(void)getData{
    GetCardDetail * detail = [[GetCardDetail alloc]init];
    detail.userId = [[UserDao sharedInstance]loadUser].userId;
    detail.cardId = self.cardId;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [detail executeHasParse:^(id jsonData) {
        hud.hidden = YES;
    self.model = [CardDetailModel initWithJSON:jsonData];
        [self fillContentWith:self.model];
        
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //隐藏卡片目标
    if (self.model.cardType == 0 || self.model.cardType == 1) {
        if (indexPath.row == 2) {
            return 0.1;
        }
    }
    //隐藏广播
    if (self.model.createCard == 1) {
        if (indexPath.row == 3) {
            return 0.1;
        }
    }
    //官方卡片
    if (self.model.cardSource == 1) {
        if (self.model.prizeName.length == 0) {
            if (indexPath.row ==4) {
                return 0.1;
            }
        }
        if (self.model.prizeDetail.length == 0) {
            if (indexPath.row == 5) {
                return 0.1;
            }
        }
        else{
            //奖励说明计算长度变换高度
            CGFloat height = [Utile getSizeWithString:self.model.prizeDetail font:15 width:VIEW_WIDTH - 125 - 8].height;
            if (height > 25) {
                //两行以上
                if (indexPath.row == 5) {
                    return height + 15 + 8;
                }
            }
        }
    }
    else{
        if (indexPath.row == 4 || indexPath.row == 5) {
            return 0.1;
        }
    
    }
    if (self.model.bewrite.length > 0) {
        CGFloat cardHe = [Utile getSizeWithString:self.model.bewrite font:15 width:VIEW_WIDTH - 125 - 8].height;
        if (cardHe > 25) {
            if (indexPath.row == 6) {
                return  cardHe + 15 + 8;
            }
        }
    }
    
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == self.timeCell) {
        NSLog(@"点击了时间");
    }
    else if (cell == self.inviteFriendCell){
        NSLog(@"点击了邀请好友");
        UIStoryboard * cardStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:[NSBundle mainBundle]];
        InviteFriendsViewController * card = [cardStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([InviteFriendsViewController class])];
        card.cardId = self.cardId;
        card.delegate = self;
        card.shareUrl = self.model.shareUrl;
        [self.navigationController pushViewController:card animated:YES];
    }

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showPicker"]) {
        TimePickerViewController * time = segue.destinationViewController;
        time.delegate = self;
        time.qcId = self.model.qcId;
        time.isRemind = self.model.isRemind;
        time.seconds = self.model.remindTime;
    }
}

#pragma InviteFriendsViewControllerDelegate
-(void)choosenFrindsCount:(NSInteger)count{
    inviCount = inviCount + count;
    self.inviteCount.text = [NSString stringWithFormat:@"叫来 %ld 个逗比",(long)inviCount];
}
#pragma TimePickerViewControllerDelegate
-(void)getResultStepWithCount:(NSInteger)count timeString:(NSString *)time{
    self.timeLabel.text = time;
}
@end
