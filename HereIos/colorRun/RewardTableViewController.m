//
//  RewardTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/10.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "RewardTableViewController.h"
#import "Masonry.h"
#import "RecoderHeadView.h"
#import "RewardTableViewCell.h"
#import "Utile.h"
#import "RDVTabBarController.h"
#import "CoolApi.h"
#import "UserDao.h"
#import "SDRefresh.h"
#import "MoneyRecordViewController.h"
#import "SignAddressViewController.h"
#import "CreditWebViewController.h"
@interface RewardTableViewController ()<RewardTableViewCellDelegate,RecoderHeadViewDelegate>

@end

@implementation RewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rewardList=[NSMutableArray array] ;
    _headView =[RecoderHeadView createHeadView] ;
    _headView.delegate = self;
    [self.tableView setTableHeaderView:_headView] ;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone ;
    [self loadData:1] ;
    self.navigationItem.title=@"运动奖励";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor] ;
//    self.navigationController.navigationItem.leftBarButtonItem.title=@"" ;
   
}
-(void)refreshData{
    _rewardList=[NSMutableArray array] ;
    [self loadData:1] ;
}

-(void) loadNext{
    NSLog(@"hasNext=%d",self.hasNext) ;
    NSInteger page = _getRewardList.pageNo ;
    [self loadData:page+1] ;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;
}

-(void) loadData:(NSInteger) page {
    UserDao* dao = [UserDao sharedInstance] ;
    _getRewardList = [[Getrewardlist alloc]init] ;
    User* user = [dao loadUser] ;
    _getRewardList.userId =user.userId ;
    _getRewardList.pageNo = page ;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [_getRewardList excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        [self endFreshing];
        hud.hidden = YES;
        NSString* code = [responseDate valueForKey:@"code"] ;
        if ([code isEqualToString:@"0"]) {
            id data = [responseDate objectForKey:@"data"] ;
            
            [_headView setRedPackageText:[data valueForKey:@"redPacket"]] ;
            NSArray* rewardArray=[data objectForKey:@"rewardList"] ;
            if (![rewardArray isEqual:[NSNull null]]) {
                for (NSDictionary* item in rewardArray) {
                    MyRewardModel* mode = [[MyRewardModel alloc]init] ;
                    for (NSString* key in [mode PropertyKeys]) {
                        [mode setValue:[item valueForKey:key] forKey:key] ;
                    }
                    _rewardList=[_rewardList arrayByAddingObject:mode] ;
                }
                [self.tableView reloadData] ;
                if (rewardArray.count%10==0) {
                    self.hasNext=YES ;
                }else{
                    self.hasNext=NO ;
                }
            }else{
                [self loadEndWithContent:@"别说奖励是浮云啊，我戒了" imageName:@"reward_not_have"] ;
                self.hasNext=NO ;
            }
        }
        else {
            [self showErrorAlertWithString:@"请求出错，请稍后再试。"];
            
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        [self showErrorAlertWithString:@"系统出错,请稍后再试~~"];
        [self endFreshing];
        hud.hidden = YES;
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return _rewardList.count;
}



#pragma RewardTableViewCellDelegate
-(void)didClickedGetGitButton:(RewardTableViewCell *)cell{
    NSLog(@"点击了领取按钮");
    MyRewardModel* model = [_rewardList objectAtIndex:cell.getGit.tag];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SignAddressViewController * sign =[borad instantiateViewControllerWithIdentifier:@"SignAddressViewController"] ;
    sign.model = model;
    [self.navigationController pushViewController:sign animated:YES] ;
    OpenReward * open = [[OpenReward alloc]init];
    open.rewardId = [model.rewardId integerValue];
    open.userID = [[UserDao sharedInstance]loadUser].userId ;
    [open excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        if ([responseDate[@"code"] isEqualToString:@"0"]) {
            NSDictionary * dic = responseDate[@"data"];
            if (dic[@"status"] ==0) {
                NSLog(@"打开成功");
            }
        }
        NSLog(@"打开失败");
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        NSLog(@"打开错误");
    }];
}

#pragma RecoderHeadViewDelegate
-(void)showMyMoneyListAction{
    NSLog(@"红包记录");
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MoneyRecordViewController *money =[borad instantiateViewControllerWithIdentifier:@"MoneyRecordViewController"] ;
    [self.navigationController pushViewController:money animated:YES] ;

}
-(void)getMoneyAction{
     User* user = [[UserDao sharedInstance]loadUser] ;
    if (user.phone==nil||user.phone.length==0) {
        [self showOkayCancelAlert];
    }else{
    NSLog(@"提现");
    GetLoginUrlApi* api = [[GetLoginUrlApi alloc]init] ;
   
    api.userId = user.userId  ;
    [api executeHasParse:^(id jsonData) {
        NSString* url = jsonData[@"url"] ;
        CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:url];//实际中需要改为开发者服务器的地址，开发者服务器再重定向到一个带签名的自动登录地址
        [self.navigationController pushViewController:web animated:YES];

    } failure:^(NSString *error) {
        
    }];
    }
}

- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"绑定手机号 奖励跑不掉", nil);
    NSString *message = NSLocalizedString(@"Here 推荐绑定手机号，不再错过一切有趣的人和事", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"以后再说", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"现在绑定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
        ResetPasswordViewController *checkCodeController=[borad instantiateViewControllerWithIdentifier:@"checkCodeController"] ;
        checkCodeController.type=2 ;
        UserbehaviorApi* api = [[UserbehaviorApi alloc]init];
        api.type=1 ;
        api.behavior=0;
        UIDevice *device =[[UIDevice alloc]init] ;
        api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
        [api executeHasParse:^(id jsonData) {
            
        } failure:^(NSString *error) {
            
        }];
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:checkCodeController] ;
       [self.navigationController presentViewController:nav animated:YES completion:nil] ;
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //指定cellIdentifier为自定义的cell
//    NSLog(@"row = %lu count=%lu",indexPath.row,_rewardList.count) ;
    MyRewardModel* model = [_rewardList objectAtIndex:indexPath.row] ;
    static NSString *CellIdentifier = @"my_cell";
    //自定义cell类
    RewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"rewardCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.getGit.tag = indexPath.row;
        [cell fillUiWithModel:model] ;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return  216.0 ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0 ;
}


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];//创建一个视图
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        headerView.backgroundColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
        headerLabel.textColor = [Utile contentBlack];
        headerLabel.text = @"活动奖励";
        [headerView addSubview:headerLabel];
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, self.tableView.frame.size.width , 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineLabel];
        return headerView ;
    }else{
        return nil;
    }
}

@end
