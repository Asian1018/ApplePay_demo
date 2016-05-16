//
//  DetailCardViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/14.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "DetailCardViewController.h"
#import "DetailCardCell.h"
#import "RDVTabBarController.h"
#import "SJAvatarBrowser.h"
#import "CardRankViewController.h"
#import "HeaderView.h"
#import "TakeCardViewController.h"
#import "CardInfoViewController.h"
#import "RunMapsViewController.h"
#import "CardResultView.h"
#import "HealthManager.h"
#import "TimePickerViewController.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
@interface DetailCardViewController ()<UIAlertViewDelegate,UIScrollViewDelegate,HeaderViewDelegate,CardInfoViewControllerDelegate,DetailCardCellDelegate,CardResultViewDelegate>{
    CardRecordList* model;
    NSInteger ViewY;
    CGFloat margent;
    UIView * drawView;
    UIButton *drawbutton;
    BOOL showView;
    UILabel* stepCount;
    UIButton* takeCardButton;
    UIButton * joinButton;//加入卡片
    BOOL takeCardSuccess;
    NSInteger healthKitCount;
    NSInteger cardMeter;
}
@property (strong, nonatomic) HeaderView *headerView;
@property(nonatomic, strong)UIView *FooterView;
@property(nonatomic,strong)NSMutableArray * cardArray;
@property(nonatomic,strong)CardInfoModel * models;
@property(nonatomic,strong)NSNotificationCenter * center;
@property(nonatomic, strong)HealthManager * manger;
@property(nonatomic)NSInteger pageNo;
@end
@implementation DetailCardViewController
-(void)showSportTypeView{
    if (self.cardType == 2 || self.cardType == 3) {
        //运动类型,显示下拉页面
        drawView = [[UIView alloc]init];
        drawView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
        drawView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMidY(drawView.frame) - 80 , CGRectGetWidth(drawView.frame) - 100, 30)];
        label.font = [UIFont systemFontOfSize:24];
        label.text = @"目标步数";
        if (self.cardType == 3) {
            //跑步
            label.text = @"目标里程";
        }
        label.textAlignment = NSTextAlignmentCenter;
        [drawView addSubview:label];
        stepCount = [[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame) + margent*2, CGRectGetWidth(label.frame), 40)];
        stepCount.font = [UIFont systemFontOfSize:40];
        stepCount.textColor = [Utile green];
        stepCount.text = @"";
        stepCount.textAlignment = NSTextAlignmentCenter;
        [drawView addSubview:stepCount];
        
        [UIView animateWithDuration:1 animations:^{
            [self.tableView addSubview:drawView];
        }];
        
    }
}

-(void)backAction{
    if (self.fromType.length > 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma DetailCardCellDelegate
-(void)showInfoWithUserId:(NSInteger)userid{
    [self showPersonInfoWithId:userid];

}
-(void)addLikeResultLogin{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
    [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
    return;
    
}
-(void)showPersonInfoWithId:(NSInteger)userId{
    NSLog(@"显示我的信息");
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = userId;
    [self.navigationController pushViewController:person animated:YES] ;

}
-(void)showMyCardInfo{
    if (self.models.userId == 0) {
        return;
    }
    [self showPersonInfoWithId:self.models.userId];
}

-(void)takeCardSuccess{
     takeCardButton.enabled = NO;
    [self getdata];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    healthKitCount = 0;
    self.pageNo = 1;
    _manger = [HealthManager shareInstance];
    takeCardSuccess = YES;
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.center = [NSNotificationCenter defaultCenter];
    [self.center addObserver:self selector:@selector(takeCardSuccess) name:TAKECARD_SUCCESS object:nil];
    showView = YES;
     margent = 8;
    self.cardArray = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self showSportTypeView];
    _headerView = [[HeaderView alloc]init];
    _headerView.delegate = self;
    self.tableView.tableHeaderView = _headerView;
    self.title = @"卡片详情";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self getdata];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_black_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    self.tableView.tableFooterView = view;
    [self creatFooterView];
}

-(void)drawMidView{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.tableView.frame.size.width, 40);
    drawbutton = [[UIButton alloc]init];
    [drawbutton setImage:[UIImage imageNamed:@"space_collapsing"] forState:UIControlStateSelected];
    [drawbutton setImage:[UIImage imageNamed:@"space_expanding"] forState:UIControlStateNormal];
    drawbutton.selected = YES;
    drawbutton.frame  = CGRectMake(self.tableView.frame.size.width / 2 - 15, 0, 30, 30);
    [drawbutton addTarget:self action:@selector(showDrawView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:drawbutton];
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, drawView.frame.size.width, 10)];
    la.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:la];
    showView = NO;
    [self.tableView addSubview:view];
}
-(UIView*)creatEmptyViewWithTitle:(NSString*)title Image:(UIImage*)image{
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, VIEW_WIDTH, self.tableView.frame.size.height - 44 -_headerView.frame.size.height - 40 - 20);
//    view.backgroundColor = [UIColor redColor];
    UIImageView * imageView = [[UIImageView alloc]init];
    if (!image) {
        imageView.image = [UIImage imageNamed:@"card_not_have"];
    }else{
        imageView.image = image;
    }
    //图片像素都是138 x 138
    imageView.frame = CGRectMake(VIEW_WIDTH/2 - 69, 100, 138, 138);
    [view addSubview:imageView];
    UILabel * la = [[UILabel alloc]init];
    la.text = title;
    la.frame = CGRectMake(16, CGRectGetMaxY(imageView.frame) +12, VIEW_WIDTH - 32, 50);
    la.font = [UIFont systemFontOfSize:18];
    la.textColor = [UIColor lightGrayColor];
    la.textAlignment = NSTextAlignmentCenter;
    la.numberOfLines = 0;
//    la.backgroundColor = [UIColor blueColor];
    [view addSubview:la];
    
    return view;
}

-(void) refreshData{
    self.pageNo = 1;
    [self getdata];
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getdata];
    
}
-(void)getdata{
    self.tableView.tableFooterView = nil;
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
    self.tableView.tableFooterView = view;
    GetCardApi * api = [[GetCardApi alloc]init];
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    api.pageNo = self.pageNo;
    api.pageSize =10;
    api.cardId = self.cardId;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [api executeHasParse:^(id jsonData) {
        [self endFreshing];
        hud.hidden = YES;
        if (self.pageNo == 1) {
            NSDictionary *  dic = jsonData[@"cardDetail"];
            NSArray *  list = jsonData[@"cardRecordList"];
            self.models = [CardInfoModel initWithJSON:dic];
            stepCount.text =[NSString stringWithFormat:@"%@", dic[@"targetValue"]];
            if (self.models.cardType == 3) {
                NSString * dis = [NSString stringWithFormat:@"%@",dic[@"targetValue"]];
                cardMeter = [dis integerValue];
                CGFloat f = [dis floatValue]/ 1000;
                stepCount.text = [NSString stringWithFormat:@"%.1f km",f];
            }
            self.title = self.models.title;
            //打卡状态 0 未加入卡片 1 已打卡 2未打卡
            switch ( self.models.clockStatus) {
                case 0:
                    [self withoutJoinCard];
                    break;
                case 1:
                    takeCardButton.enabled = NO;
                    break;
                case 2:
                    
                    break;
                    
                default:
                    break;
            }
            [_headerView fillWithModel:self.models];
            self.tableView.tableHeaderView = _headerView;
//            [self.tableView reloadData];
            [_cardArray removeAllObjects];
            if ([list isEqual:[NSNull null]]) {
                if (self.cardType < 2 ) {
                    self.tableView.tableFooterView = [self creatEmptyViewWithTitle:@"这班逗比很懒，啥都没留下 除了鄙视他们，你可以打卡炫耀~" Image:nil];
                    self.hasNext = NO;
                    return ;
                }
                    [self drawMidView];
                    if (drawView.hidden == YES) {
                        drawbutton.selected = NO;
                        self.tableView.tableFooterView = [self creatEmptyViewWithTitle:@"这班逗比很懒，啥都没留下 除了鄙视他们，你可以打卡炫耀~" Image:nil];
                    }
            }
            else{
                for (id item in list) {
                    CardRecordList* card = [CardRecordList initWithJSON:item] ;
                    [_cardArray addObject:card];
                }
                if (_cardArray.count < 10) {
                    self.hasNext = NO;
                }
                else{
                    self.hasNext = YES;
                }
            }
            [self.tableView reloadData];
        }
        else{
        //加载更多
         NSArray *  list = jsonData[@"cardRecordList"];
            if ([list isEqual:[NSNull null]]) {
                if (self.cardType < 2 ) {
                    [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                    self.hasNext = NO;
                    return ;
                }
            }
            else{
                for (id item in list) {
                    CardRecordList* card = [CardRecordList initWithJSON:item] ;
                    [_cardArray addObject:card];
                }
                if (_cardArray.count%10==0) {
                    self.hasNext=YES ;
                }
                else{
                    self.hasNext=NO ;
                }
                [self.tableView reloadData];
            }
        }
        
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [self endFreshing];
        [Utile showPromptAlertWithString:error];
    }];

}
-(void)joinAction{
    if ([[UserDao sharedInstance]loadUser].userId < 1) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    if (self.models.cardStatus == 1) {
        [Utile showWZHUDWithView:self.navigationController.view andString:@"这卡片刚结束~~下一个在路上"];
        return;
    }
    
    AddCard * add = [[AddCard alloc]init];
    add.userId = [[UserDao sharedInstance]loadUser].userId;
    add.cardId = self.cardId;
    MBProgressHUD * huds = [Utile showHudInView:self.navigationController.view];
    [add executeHasParse:^(id jsonData) {
        huds.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
            //加入成功
            [Utile showWZHUDWithView:self.navigationController.view andString:@"加入成功"];
            self.models.qcId =[[NSString stringWithFormat:@"%@",jsonData[@"qcId"]] integerValue];
            [joinButton removeFromSuperview];
            UIStoryboard *borad = [UIStoryboard storyboardWithName:@"CardInfo" bundle:[NSBundle mainBundle]];
            TimePickerViewController * time  =[borad instantiateViewControllerWithIdentifier:NSStringFromClass([TimePickerViewController class])] ;
            time.qcId = self.models.qcId;
            time.isRemind = 0;
            time.fromType = @"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
            [self.navigationController pushViewController:time animated:YES];
        }
        else{
            [Utile showPromptAlertWithString:@"加入失败"];
        }
        
    } failure:^(NSString *error) {
        huds.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
}
-(void)withoutJoinCard{
    joinButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 44)];
    joinButton.backgroundColor = [Utile green];
   [joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinButton setTitle:@"加入卡片" forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont systemFontOfSize:22];
    [joinButton addTarget:self action:@selector(joinAction) forControlEvents:UIControlEventTouchUpInside];
    [_FooterView addSubview:joinButton];
}
-(void)creatFooterView{
    _FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.bounds.size.height - 44 + 20, self.tableView.frame.size.width, 44)];
    ViewY = (NSInteger)_FooterView.frame.origin.y;
    //详情
    UIButton * detail = [[UIButton alloc]initWithFrame:CGRectMake(margent, 0, 44, 44)];
    [detail setTitleColor:[Utile green] forState:UIControlStateNormal];
    [detail setTitle:@"详情" forState:UIControlStateNormal];
    [detail addTarget:self action:@selector(showCardDetailView) forControlEvents:UIControlEventTouchUpInside];
    [_FooterView addSubview:detail];
    
    //打卡
    takeCardButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.FooterView.frame) - 22, 0, 44, 44)];
    [_FooterView addSubview:takeCardButton];
    [takeCardButton setImage:[UIImage imageNamed:@"register_normal"] forState:UIControlStateNormal];
    [takeCardButton setImage:[UIImage imageNamed:@"register_press"] forState:UIControlStateDisabled];
    [takeCardButton addTarget:self action:@selector(takeCardAction) forControlEvents:UIControlEventTouchUpInside];

    //榜单
    UIButton * listButton = [[UIButton alloc]initWithFrame:CGRectMake(self.FooterView.frame.size.width - 44 - margent , 0, 44, 44)];
    [listButton setTitleColor:[Utile green] forState:UIControlStateNormal];
    [listButton setTitle:@"榜单" forState:UIControlStateNormal];
    [listButton addTarget:self action:@selector(showListAction) forControlEvents:UIControlEventTouchUpInside];
    [_FooterView addSubview:listButton];
    
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(0, 0, VIEW_WIDTH, 0.5);
    [_FooterView addSubview:line];
    [self.tableView addSubview:_FooterView];
    
    _FooterView.backgroundColor = [UIColor whiteColor];

}
-(void)logoutAction{
    [self withoutJoinCard];

}
//详情
-(void)showCardDetailView{
    NSLog(@"详情");
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"CardInfo" bundle:[NSBundle mainBundle]];
    CardInfoViewController *info =[borad instantiateViewControllerWithIdentifier:NSStringFromClass([CardInfoViewController class])] ;
    info.cardId = self.cardId;
    info.delagate = self;
    [self.navigationController pushViewController:info animated:YES];
}
-(void)dismissViewAction{
    if (takeCardSuccess == YES) {
        NSLog(@"达标,可以打卡");
        [self jumpTakeView];
    }
}
-(void)takeCardAction{
    if (self.models.cardStatus == 1) {
        [Utile showWZHUDWithView:self.navigationController.view andString:@"这卡片结束了~~打卡是逗比"];
        return;
    }
    NSLog(@"打卡");
    if (self.models.cardType == 2) {
       //计步 取healthkit数据比较,成功后帮他打卡
        MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
        [_manger getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
            NSLog(@"当天行走步数111 = %.0lf",value);
         healthKitCount = [[NSString stringWithFormat:@"%f",value] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^(){
                hud.hidden = YES;
                NSString *str = @"没获取到健康中心数据";
                if (value > 0) {
                    str = [NSString stringWithFormat:@"今天总步数:%.0lf,",value];
                    if (healthKitCount >= self.models.targetValue) {
                        //达标
                        str = [NSString stringWithFormat:@"%@前往打卡",str];
                    }
                    else{
                        takeCardSuccess = NO;
                     str = [NSString stringWithFormat:@"%@打卡失败",str];
                    }
                }
                else{
                    takeCardSuccess = NO;
                }
                CardResultView * cardView = [[CardResultView alloc]initWithCountString:str];
                cardView.delegate = self;
                cardView.frame = self.tableView.frame;
                [self.tableView addSubview:cardView];
            });
            
        }];
        
        
    }
    else if (self.models.cardType == 3){
        //跑步,直接跳到跑步页面
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"CoolMap" bundle:[NSBundle mainBundle]];
        RunMapsViewController *run = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([RunMapsViewController class])] ;
        run.sportMode = 1;
#warning 卡片类型的跑步
        run.sportType = 2;//有待确定,应该是为2
        run.cardMeter = cardMeter;
        run.models = self.models;
        [self.navigationController pushViewController:run animated:YES] ;
    }
    
    else{
        [self jumpTakeView];
    }
}
-(void)jumpTakeView{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"TakeCard" bundle:[NSBundle mainBundle]];
    TakeCardViewController *takeCard =[borad instantiateViewControllerWithIdentifier:NSStringFromClass([TakeCardViewController class])] ;
    CardShareData * data = [[CardShareData alloc]init];
    data.qcId = self.models.qcId;
    data.userId = [[UserDao sharedInstance]loadUser].userId;
    data.cardId = self.models.cardId;
    data.title = [NSString stringWithFormat:@"坚持#%@#%ld天",self.models.title,(long)self.models.userDays + 1];
    data.target = self.models.target;
    data.targetValue = self.models.targetValue;
    takeCard.takeCardApi = data;
    takeCard.cardType = self.models.cardType;
    takeCard.userDays = self.models.userDays;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:takeCard];
    [self.navigationController presentViewController:nav animated:YES completion:nil];

}
//榜单
-(void)showListAction{
    NSLog(@"榜单");
    CardRankViewController * rank = [[CardRankViewController alloc]init];
    rank.cardId = self.cardId;
    [self.navigationController pushViewController:rank animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.cardArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.cardType == 2 || self.cardType == 3) {
        if (section == 0) {
            return 40;
        }
        //运动类型,显示下拉页面
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.cardType == 2 || self.cardType == 3) {
        if (section == 0) {
            UIView * view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];
            view.frame = CGRectMake(0, 0, tableView.frame.size.width, 40);
            drawbutton = [[UIButton alloc]init];
            [drawbutton setImage:[UIImage imageNamed:@"space_collapsing"] forState:UIControlStateSelected];
            [drawbutton setImage:[UIImage imageNamed:@"space_expanding"] forState:UIControlStateNormal];
            drawbutton.selected = YES;
            drawbutton.frame  = CGRectMake(tableView.frame.size.width / 2 - 15, 0, 30, 30);
            [drawbutton addTarget:self action:@selector(showDrawView) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:drawbutton];
            UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, drawView.frame.size.width, 10)];
            la.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [view addSubview:la];
            
            return view;
        }
    }
    return nil;
}
//显示或收起下拉页面
-(void)showDrawView{
    drawbutton.selected = !drawbutton.selected;
    if (drawbutton.selected) {
//        [UIView animateWithDuration:1 animations:^{
            drawView.hidden = NO;
            UIView * view = [[UIView alloc]init];
            view.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 60);
            self.tableView.tableFooterView = view;
//        }];
        return;
    }
        drawView.hidden = YES;
        if (!showView) {
            if (self.cardArray.count == 0) {
               self.tableView.tableFooterView = [self creatEmptyViewWithTitle:@"这班逗比很懒，啥都没留下 除了鄙视他们，你可以打卡炫耀~" Image:nil];
            }
        }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"detailCell";
    DetailCardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CardRecordList *list = [self.cardArray objectAtIndex:indexPath.section];
    if (cell == nil) {
        cell = [[DetailCardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell setcontantWithModel:list cardId:self.cardId];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CardRecordList *car = [self.cardArray objectAtIndex:indexPath.section];
    NSInteger iTop = [DetailCardCell heightWithModel:car];
    return iTop;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _FooterView.frame = CGRectMake(_FooterView.frame.origin.x, ViewY+self.tableView.contentOffset.y , _FooterView.frame.size.width, _FooterView.frame.size.height);
}
@end
