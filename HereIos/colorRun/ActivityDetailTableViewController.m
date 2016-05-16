//
//  ActivityDetailTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/24.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "ActivityDetailTableViewController.h"
#import "UserDao.h"
#import "HonorTableViewCell.h"
#import "RDVTabBarController.h"
#import "Masonry.h"
#import "UILabel+AutoHeight.h"
#import "HonorTableViewController.h"
#import "PersonInfoViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "RunMapsViewController.h"
#import "MyRecordViewController.h"
#import "LoginViewController.h"
#import "PadingLabel.h"
@interface ActivityDetailTableViewController ()<UIAlertViewDelegate>{
    
    
}
@property(nonatomic,strong) NSMutableArray* honorList ;
@property(nonatomic,strong) ActivityHeadView* headView ;
@property(nonatomic,strong) ActivityDetail* activityDetail ;
@property(nonatomic,strong) ActivityUser* activityUser ;
@property(nonatomic,strong) NSArray* imageArray ;
@property(nonatomic)NSInteger type;
@property(nonatomic,strong)NSMutableSet * SportSet;
@end

@implementation ActivityDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString * token = [[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_TOKEN];
    _honorList=[NSMutableArray array] ;
    _imageArray=@[@"honor_first",@"honor_second",@"honor_third",@""] ;
    self.automaticallyAdjustsScrollViewInsets = YES ;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"活动详情";
    self.tableView.delegate=self ;
    self.tableView.dataSource=self ;
   // [self getData:NO] ;
}

-(void) refreshData{
    [self getData:YES] ;
}
-(BOOL) needNext{
    return NO ;
}
-(void) getData:(BOOL) isRefresh{
    CoolActivityDetail* detail = [[CoolActivityDetail alloc]init] ;
    detail.oaId=_aId ;
    detail.userId=[[UserDao sharedInstance]loadUser].userId  ;
    MBProgressHUD* hud ;
    if (!isRefresh) {
         hud= [Utile showHudInView:self.navigationController.view];
    }
    [detail executeHasParse:^(id jsonData) {
        if (!isRefresh) {
           hud.hidden = YES;
        }
        [self parseActivityDetail:[jsonData objectForKey:@"activityDetail"]] ;
        [self parseHonor:[jsonData objectForKey:@"honorList"]] ;
        [self parseActivityUser:[jsonData objectForKey:@"activityUser"]] ;
        if (!isRefresh) {
            [self parseEnd] ;
        }else{
            //[self endFreshing] ;
            [self.tableView reloadData] ;
        }
    } failure:^(NSString *error) {
        if (!isRefresh) {
            hud.hidden = YES;
        }
    }];
}

-(void) parseActivityDetail:(id) detail{
    if ([detail isEqual:[NSNull null]]) {
        return;
    }
    self.type =[[NSString stringWithFormat:@"%@",detail[@"type"]] integerValue];
    _activityDetail = [[ActivityDetail alloc] init] ;
    for (NSString* key  in [_activityDetail PropertyKeys]) {
        [_activityDetail setValue:[detail objectForKey:key] forKey:key] ;
    }
    if (_activityDetail.oaId > 0) {
        NSString * key = [NSString stringWithFormat:@"S_%ld",(long)[[UserDao sharedInstance]loadUser].userId];
        if ([[NSUserDefaults standardUserDefaults]valueForKey:key]) {
             self.SportSet = [NSMutableSet setWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:key]];
            return;
        }
        self.SportSet = [NSMutableSet set];
    }
    //TODO fill head
}

-(void) parseHonor:(id) honorList{
    if ([honorList isEqual:[NSNull null]]) {
        return;
    }
    [_honorList removeAllObjects] ;
    for (id honor in honorList) {
        HonorModel* model= [[HonorModel alloc]init] ;
        for (NSString* key in [model PropertyKeys]) {
            [model setValue:[honor objectForKey:key] forKey:key] ;
        }
        [_honorList addObject:model] ;
    }
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData:NO] ;
}
-(void) parseActivityUser:(id) activityUser{
    if ([activityUser isEqual:[NSNull null]]) {
        return;
    }
    _activityUser = [[ActivityUser alloc]init];
    for (NSString* key in [_activityUser PropertyKeys]) {
        [_activityUser setValue:[activityUser objectForKey:key] forKey:key];
    }
}

-(void) parseEnd{
    //    [_headView fillUiWhitActivityDetail:_activityDetail withActivityUser:_activityUser] ;
    UIView* headView = [self posterView] ;
    //    CGSize size =[headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
    //    NSLog(@"head size=%f",size.height);
    //    headView.frame=CGRectMake(0, 0, size.width, size.height) ;
    [self.tableView setTableHeaderView:headView] ;
    if (_activityDetail) {
      [self createFootView] ;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (_honorList.count > 5) {
        return 5;
    }
    return _honorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HonorModel* model =[_honorList objectAtIndex:indexPath.row] ;
    model.type = self.type;
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"activity_honor_cell";
    //自定义cell类
    HonorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"activity_cell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < _imageArray.count) {
        [cell withIcon:[_imageArray objectAtIndex:indexPath.row] index:indexPath.row type:self.type];
    }else {
        [cell withIcon:@"honor_bg" index:indexPath.row type:self.type];
    }
    [cell fillUiWithModel:model] ;
    if (model.type == 0) {
        cell.time.text = @"已挑战";
    }
    if (_activityUser.target == 0) {
        cell.time.text = [NSString stringWithFormat:@"%@km",model.kilometer];
    }
    return cell;
    
}

-(void)action:(id)sender{
    HonorTableViewController* honorController =[[HonorTableViewController alloc]init] ;
    honorController.oId=_activityDetail.oaId ;
    [self.navigationController pushViewController:honorController animated:YES] ;
}
-(void)channege:(id)sender{
    User * user = [[UserDao sharedInstance]loadUser];
    if (user == nil) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    if (_activityDetail.status == 4) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"活动还没开始呦~现在不计入成绩" delegate:self cancelButtonTitle:@"暂时不跑" otherButtonTitles:@"先热热身", nil];
        alert.tag = 1;
        [alert show];
        return;
    }
    
    if ([self.SportSet containsObject:[NSString stringWithFormat:@"S_%ld",(long)_activityDetail.oaId]]) {
        [self jumpToMapView];
    }
    
    else{
        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"摩拳擦掌了吧~立马挑战拿奖品吧" delegate:self cancelButtonTitle:@"好紧张,先平复一下" otherButtonTitles:@"现在就挑战", nil];
        al.tag = 2;
        [al show];
        if (_activityDetail.oaId > 0) {
            NSString * soprtString = [NSString stringWithFormat:@"S_%ld",(long)user.userId];
           
            [self.SportSet addObject:[NSString stringWithFormat:@"S_%ld",(long)_activityDetail.oaId]];

            if ([[NSUserDefaults standardUserDefaults]valueForKey:soprtString]) {
                [[NSUserDefaults standardUserDefaults]setValue:self.SportSet.allObjects  forKey:soprtString];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:self.SportSet.allObjects forKey:soprtString];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
    }
}
-(void)jumpToMapView{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"CoolMap" bundle:[NSBundle mainBundle]];
    RunMapsViewController *run = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([RunMapsViewController class])] ;
    run.sportMode = _activityDetail.sportMode;
    run.sportType = 1;
    run.activityId = _activityDetail.oaId;
    run.activityDetail = _activityDetail;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:run animated:YES] ;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            //跑步
            [self jumpToMapView];
        }
        
    }
    else if (alertView.tag == 2){
        if (buttonIndex == 1) {
            //跑步
            [self jumpToMapView];
        }
    }
}

-(UIView*) posterView{
    UIFont * font = [UIFont systemFontOfSize:15];
    if (self.view.bounds.size.width < 330) {
        font = [UIFont systemFontOfSize:13];
    }
    UIView* postView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 1800)];
    UIView* contenView =[[UIView alloc]init] ;
    postView.backgroundColor=[Utile background];
    UIImageView* postImage= [[UIImageView alloc]init] ;
    UIView* descLayout=[[UIView alloc]init] ;
    UILabel* timeLable =[[UILabel alloc]init] ;
    timeLable.textColor=[UIColor whiteColor];
    timeLable.font = font;
    UILabel* numberlabel=[[UILabel alloc]init] ;
    numberlabel.textColor=[Utile green];
    numberlabel.font = font;
    [postImage sd_setImageWithURL:[NSURL URLWithString:_activityDetail.subPoster]] ;
    timeLable.text=[NSString stringWithFormat:@"距离结束时间还有:%@",_activityDetail.times];
    numberlabel.text=[NSString stringWithFormat:@"已参加人数:%lu",_activityDetail.count];
    descLayout.backgroundColor=[Utile colorWithHex:0x000000 alpha:0.5] ;
    //个人的头部
    UIView* personHead=[[UIView alloc]init] ;
    personHead.backgroundColor=[UIColor whiteColor] ;
    UIImageView* avatarIcon=[[UIImageView alloc]init] ;
    avatarIcon.image=[UIImage imageNamed:@"ico_mine"] ;
    UILabel* label=[[UILabel alloc]init];
    label.text=@"个人";
    UILabel* line=[[UILabel alloc]init];
    line.backgroundColor=[Utile line];
    line.text=@" ";
    UIView* userInfo = [self userInfoLayout] ;
    //    [personHead addSubview:userInfo] ;
    [personHead addSubview:avatarIcon];
    [personHead addSubview:label] ;
    [personHead addSubview:line] ;
    [avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personHead.mas_top).offset(8);
        make.left.equalTo(personHead.mas_left).offset(8);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(avatarIcon.mas_centerY);
        make.left.equalTo(avatarIcon.mas_right).offset(8);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(8);
        make.left.equalTo(personHead.mas_left);
        make.right.equalTo(personHead.mas_right);
        make.height.equalTo(@1) ;
    }];
    //    [userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(line.mas_bottom).offset(8) ;
    //        make.left.equalTo(personHead.mas_left) ;
    //    }];
    [contenView addSubview:userInfo] ;
    [descLayout addSubview:timeLable];
    [descLayout addSubview:numberlabel] ;
    [contenView addSubview:postImage];
    [contenView addSubview:descLayout] ;
    [contenView addSubview:personHead];
    [postView addSubview:contenView] ;
    [postImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contenView.mas_left);
        make.right.equalTo(contenView.mas_right);
        make.top.equalTo(contenView.mas_top) ;
        make.height.equalTo(@200);
    }];
    [descLayout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(postImage.mas_left);
        make.right.equalTo(contenView.mas_right) ;
        make.bottom.equalTo(postImage.mas_bottom) ;
    }];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descLayout.mas_left).offset(8);
        make.bottom.equalTo(descLayout.mas_bottom).offset(-4);
        make.top.equalTo(descLayout.mas_top).offset(4);
        make.right.greaterThanOrEqualTo(numberlabel.mas_left);
    }];
    [numberlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(descLayout.mas_right).offset(-8);
        make.bottom.equalTo(descLayout.mas_bottom) ;
        make.centerY.equalTo(timeLable.mas_centerY) ;
    }];
    [personHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contenView.mas_left);
        make.top.equalTo(postImage.mas_bottom).offset(8);
        make.right.equalTo(postImage.mas_right);
        make.bottom.equalTo(avatarIcon.mas_bottom).offset(9);
    }];
    [userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contenView.mas_left) ;
        make.top.equalTo(personHead.mas_bottom);
        
    }];
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(postView.mas_top);
        make.left.equalTo(postView.mas_left);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.bottom.equalTo(userInfo.mas_bottom).offset(8);
    }];
    CGSize size =[contenView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
//    NSLog(@"postsize=%f",size.height) ;
    postView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height) ;
    return postView;
}
-(UILabel*) createUserInfoLabel:(NSString*) title{
    UILabel* label =[[UILabel alloc]init] ;
    label.text=title ;
    label.textColor=[Utile contentBlack] ;
    label.font=[UIFont systemFontOfSize:16] ;
    return label ;
}
-(void)showInfoButtonClicked{
    if ([[UserDao sharedInstance]loadUser] ==nil) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    
    MyRecordViewController * record = [[MyRecordViewController alloc]init];
    record.oaId = self.aId;
//    record.size = 10;
    if (_activityUser.userCount > 0) {
      record.size = _activityUser.userCount;
    }
    [self.navigationController pushViewController:record animated:YES] ;
}

-(UIView*) userInfoLayout{
    NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile colorWithHex:0xbe6176 alpha:1]} ;
    UIView* userInfoView = [[UIView alloc]init] ;
    UIImageView* avatar = [[UIImageView alloc]init];
    avatar.image=[UIImage imageNamed:@"my_voucher"] ;
    UILabel* nameLabel=[self createUserInfoLabel:@"还没登录"] ;
    UILabel* changeNumber=[self createUserInfoLabel:@"还没挑战任务"] ;
    if ([[UserDao sharedInstance]loadUser] != nil) {
        nameLabel.text =[[UserDao sharedInstance]loadUser].nickName;
        [avatar sd_setImageWithURL:[NSURL URLWithString:[[UserDao sharedInstance]loadUser].avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
//        changeNumber.text = @"活动已结束";
    }
    UILabel* bestTime ;
    if (_activityDetail.claim==2) {//里程为目标
        bestTime=[self createUserInfoLabel:@"最佳里程"];
    }else{
        bestTime=[self createUserInfoLabel:@"最佳时间"];
    }
  
    UILabel* bestTimeContent=[self createUserInfoLabel:@"--"] ;
    UILabel* bestSpeed=[self createUserInfoLabel:@"配速"];
    
    UILabel* bestPeedContent=[self createUserInfoLabel:@"--"];
    bestPeedContent.textAlignment = NSTextAlignmentCenter;
    bestTimeContent.textAlignment = NSTextAlignmentCenter;
    bestSpeed.textAlignment = NSTextAlignmentCenter;
    UIButton * button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor clearColor];
//    button.enabled = NO;
    if (self.tableView.frame.size.width < 322) {
        //4.0屏幕,缩小字体适应
        UIFont * font = [UIFont systemFontOfSize:15];
        changeNumber.font = font;
        bestPeedContent.font = font;
        bestTimeContent.font = font;
        
    }
    [button addTarget:self action:@selector(showInfoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    if (_activityUser) {
        [avatar sd_setImageWithURL:[NSURL URLWithString:_activityUser.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]] ;
        nameLabel.text =  _activityUser.nickName ;
        
        NSString* change=[NSString stringWithFormat:@"挑战任务%lu次",_activityUser.userCount] ;
        NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:change];
        [changeText addAttributes:fontDict range:NSMakeRange(4,[NSString stringWithFormat:@"%ld",(long)_activityUser.userCount].length)] ;
        changeNumber.text =  [NSString stringWithFormat:@"挑战%lu次",_activityUser.userCount];
        changeNumber.attributedText=changeText ;
        bestTimeContent.textColor=[Utile colorWithHex:0xbe6176 alpha:1] ;
        if (_activityDetail.claim==2) {
            bestTimeContent.text = _activityUser.kilometer ;
        }else{
            bestTimeContent.text = _activityUser.period ;
        }
        bestPeedContent.text = [NSString stringWithFormat:@"%@/km",_activityUser.pace];
        if (_activityUser.target == 0) {
            bestTime.text = @"最佳里程";
            bestTimeContent.text = [NSString stringWithFormat:@"%@km",_activityUser.kilometer];
        }
    }

        [userInfoView addSubview:button];
        [userInfoView addSubview:avatar];
        [userInfoView addSubview:changeNumber];
        [userInfoView addSubview:bestSpeed] ;
        [userInfoView addSubview:bestTime] ;
        [userInfoView addSubview:bestTimeContent] ;
        [userInfoView addSubview:bestPeedContent] ;
        [userInfoView addSubview:nameLabel] ;
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userInfoView) ;
            make.left.equalTo(userInfoView.mas_left).offset(8) ;
            make.top.equalTo(userInfoView.mas_top).offset(8) ;
            make.width.equalTo(@66);
            make.height.equalTo(@66) ;
            avatar.layer.cornerRadius = 33 ;
            avatar.clipsToBounds = YES;
           
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatar.mas_right).offset(8) ;
            make.top.equalTo(userInfoView.mas_top).offset(8) ;
        }] ;
        [changeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_left) ;
            make.top.equalTo(nameLabel.mas_bottom).offset(8) ;
            make.height.equalTo(nameLabel.mas_height) ;
            
        }];
        [bestTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_top) ;
            make.right.equalTo(bestSpeed.mas_left).offset(-8);
            make.height.equalTo(nameLabel.mas_height) ;
//            make.centerX.equalTo(userInfoView.mas_centerX).offset(60) ;
//            make.top.equalTo(userInfoView.mas_top).offset(8) ;
//            make.height.equalTo(nameLabel.mas_height) ;
//            make.height.equalTo(nameLabel.mas_height) ;
            
        }];
        [bestTimeContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bestTime.mas_left);
            make.top.equalTo(changeNumber.mas_top) ;
            make.height.equalTo(nameLabel.mas_height) ;
            make.width.equalTo(bestTime.mas_width);
        }];
        [bestSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(userInfoView.mas_right).offset(-8) ;
            make.top.equalTo(nameLabel.mas_top) ;
            make.height.equalTo(nameLabel.mas_height) ;
        }] ;
        [bestPeedContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bestSpeed.mas_left) ;
            make.bottom.equalTo(userInfoView.mas_bottom).offset(-8) ;
            make.height.equalTo(nameLabel.mas_height) ;
            make.width.equalTo(bestSpeed.mas_width);
        }];
        [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width)) ;
            make.bottom.equalTo(changeNumber.mas_bottom).offset(8);
        }] ;
        //    userInfoView.backgroundColor=[UIColor redColor] ;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userInfoView.mas_left).offset(0);
            make.bottom.equalTo(userInfoView.mas_bottom).offset(0) ;
            make.top.equalTo(userInfoView.mas_top).offset(0) ;
            make.right.equalTo(userInfoView.mas_right).offset(0) ;
            
        }];
    
//        UIImageView* imageView = [[UIImageView alloc]init] ;
//        imageView.image=[UIImage imageNamed:@"empty_empty"] ;
//        [userInfoView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(userInfoView.mas_centerX) ;
//            make.centerY.equalTo(userInfoView.mas_centerY) ;
//        }];
//        [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width)) ;
//            make.bottom.equalTo(imageView.mas_bottom).offset(8);
//        }] ;
//    }
    userInfoView.backgroundColor=[UIColor whiteColor] ;
    CGSize size = [userInfoView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
    NSLog(@"size--height=%f",size.height) ;
    return userInfoView ;
}


-(UIView*) labelWithContent:(NSString*) content title:(NSString*)title{
    UIView* view = [[UIView alloc]init] ;
    
    UILabel* colorLabel=[[UILabel alloc]init];
    colorLabel.text=@" " ;
    colorLabel.backgroundColor=[Utile green];
    UILabel* titleLabel=[[UILabel alloc]init];
    titleLabel.text=title ;
    titleLabel.textColor=[Utile titleGray] ;
    titleLabel.font = [UIFont systemFontOfSize:19];
     view.backgroundColor=[UIColor whiteColor] ;
    
    UILabel* officiaContent =[[PadingLabel alloc]init];
    UIFont* font = [UIFont systemFontOfSize:17] ;
    officiaContent.text=content;
    officiaContent.font=font ;
    officiaContent.numberOfLines=0 ;
    officiaContent.backgroundColor=[UIColor whiteColor] ;
    view.backgroundColor=[UIColor whiteColor] ;
    officiaContent.textColor=[Utile contentBlack] ;
    
    [view addSubview:colorLabel];
    [view addSubview:titleLabel] ;
    [view addSubview:officiaContent];
    
    [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.width.equalTo(@5);
        make.top.equalTo(view.mas_top) ;
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(colorLabel.mas_right).offset(16);
        make.top.equalTo(view.mas_top) ;
    }];
    
    [officiaContent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom) ;
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right) ;
    }];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        NSLog(@"view %@ %@",content,title) ;
        if ([content length]==0) {
            make.height.equalTo(@0) ;
            view.clipsToBounds=YES ;
        }else{
            make.bottom.equalTo(officiaContent.mas_bottom);
        }
        
    }];
    [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return view ;
}

//创建查看所有荣誉按钮，如果没有数据则显示无数据图片
-(UIView*) createEmptyHonor{
    UIView* view = [[UIView alloc]init] ;
    if (_honorList.count==0) {
        UIImageView* imageView = [[UIImageView alloc]init] ;
        imageView.image=[UIImage imageNamed:@"empty"] ;
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX) ;
            make.top.equalTo(view.mas_top);
            make.bottom.equalTo(view.mas_bottom).offset(-8) ;
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width)) ;
        }];

    }else if (_honorList.count > 5){
        UIButton* allHonorButton = [[UIButton alloc]init] ;
        [allHonorButton setTitle:@"查看完整荣誉榜" forState:UIControlStateNormal] ;
        CGFloat top = 10; // 顶端盖高度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, top, top, top);
        UIImage *image = [UIImage imageNamed:@"frame"] ;
        image= [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [allHonorButton setBackgroundImage:image forState:UIControlStateNormal] ;
        [allHonorButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal] ;
        [allHonorButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:allHonorButton] ;
        [allHonorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX) ;
            make.top.equalTo(view.mas_top).offset(8);
            make.bottom.equalTo(view.mas_bottom).offset(-8) ;
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([UIScreen mainScreen].bounds.size.width)) ;
        }];
    }
    CGSize size = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize] ;
    view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height) ;
    view.backgroundColor=[UIColor whiteColor] ;
    return view ;
}
-(void) initUIButton{
       self.changleButton.backgroundColor=[Utile green] ;
        [self.changleButton setTitle:@"挑战任务" forState:UIControlStateNormal];
    switch (_activityDetail.status) {
        case 2:
            [self.changleButton setTitle:@"继续挑战" forState:UIControlStateNormal];
            break;
        case 3:
            [self.changleButton setTitle:@"挑战成功" forState:UIControlStateNormal];
            [self.changleButton setBackgroundColor:[Utile titleGray]];
            self.changleButton.enabled = NO;
            break;
        case 5:
            [self.changleButton setTitle:@"任务已结束" forState:UIControlStateNormal];
            self.changleButton.enabled = NO;
            [self.changleButton setBackgroundColor:[Utile titleGray]];
            break;
        default:
            [self.changleButton setTitle:@"挑战任务" forState:UIControlStateNormal];
            break;
            
    }
    NSLog(@"status=%lu title=%@",_activityDetail.status,self.changleButton.titleLabel.text) ;
    [self.changleButton addTarget:self action:@selector(channege:) forControlEvents:UIControlEventTouchUpInside];
   
}
-(void) createFootView{
    int marginTop = 10 ;
//    NSNumber * offsetMargin = @35;
    UIView* tableFootView = [[UIView alloc]init] ;
    //    tableFootView.backgroundColor=[UIColor greenColor] ;
    tableFootView.backgroundColor=[Utile background] ;
    UIView* footView = [[UIView alloc]init] ;
   // UIView* descTitle=[self labelWithTitle:@"活动介绍"];
    UIView* allHonorButton = [self createEmptyHonor];
    UIView* descContent=[self labelWithContent:_activityDetail.activities title:@"活动介绍"];
        
    UIView* rewardContent=[self labelWithContent:_activityDetail.reward title:@"活动奖励"];
    
    
    UIView* rewardGrantContent=[self labelWithContent:_activityDetail.rewardGrant title:@"活动备注"];
    
 
    UIView* tipsContent = [self labelWithContent:_activityDetail.tips title:@"温馨提示"];
 
    
    UIView* officiaContent =[self labelWithContent:_activityDetail.officia title:@"官方声明"];
    [self initUIButton] ;
    //挑战任务按
//    UIButton* channegeBtn =[self createUIButton];
   
//     CGSize testsize = [test systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    test.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, testsize.height) ;

//    channegeBtn.backgroundColor=[Utile green] ;
//    [channegeBtn setTitle:@"挑战任务" forState:UIControlStateNormal];
//    switch (_activityDetail.status) {
//        case 2:
//            [channegeBtn setTitle:@"继续挑战" forState:UIControlStateNormal];
//            break;
//        case 3:
//            [channegeBtn setTitle:@"挑战成功" forState:UIControlStateNormal];
//            [channegeBtn setBackgroundColor:[Utile titleGray]];
//            channegeBtn.enabled = NO;
//            break;
//        case 5:
//            [channegeBtn setTitle:@"任务已结束" forState:UIControlStateNormal];
//            channegeBtn.enabled = NO;
//            [channegeBtn setBackgroundColor:[Utile titleGray]];
//            break;
//        default:
//            break;
//
//    }
//    [channegeBtn addTarget:self action:@selector(channege:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:allHonorButton] ;
    [tableFootView addSubview:footView] ;
    [footView addSubview:tipsContent] ;
    [footView addSubview:officiaContent] ;
    [footView addSubview:descContent];
  
    [footView addSubview:rewardGrantContent] ;
    [footView addSubview:rewardContent];
//    [footView addSubview:channegeBtn] ;
    
    [allHonorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX) ;
        make.top.equalTo(footView.mas_top).offset(2);
    }] ;
    [descContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allHonorButton.mas_bottom).offset(marginTop) ;
        make.left.equalTo(footView.mas_left) ;
        make.right.equalTo(footView.mas_right) ;
        //make.height.equalTo(offsetMargin);
    }];
    

    [rewardContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descContent.mas_left);
        make.top.equalTo(descContent.mas_bottom).offset(marginTop) ;
        make.right.equalTo(footView.mas_right).offset(0) ;
    }];
    
    [rewardGrantContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descContent.mas_left) ;
        make.top.equalTo(rewardContent.mas_bottom).offset(marginTop);
        make.right.equalTo(footView.mas_right).offset(0) ;
    }];
    
    [tipsContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descContent.mas_left) ;
        make.top.equalTo(rewardGrantContent.mas_bottom).offset(marginTop) ;
        make.right.equalTo(footView.mas_right).offset(0) ;
        
    }];
    [officiaContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descContent.mas_left);
        make.top.equalTo(tipsContent.mas_bottom).offset(marginTop);
        make.right.equalTo(footView.mas_right).offset(0) ;
    }];
//    [channegeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(footView.mas_left) ;
//        make.right.equalTo(footView.mas_right) ;
//        make.top.equalTo(officiaContent.mas_bottom).offset(8) ;
//        make.height.equalTo(@60) ;
//    }] ;
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(officiaContent.mas_bottom) ;
        make.top.equalTo(tableFootView.mas_top) ;
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width)) ;
    }] ;
    CGSize size = [footView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    NSLog(@"main screen= %f",[UIScreen mainScreen].bounds.size.width) ;
    tableFootView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height) ;
    [self.tableView setTableFooterView:tableFootView] ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72 ;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_activityDetail) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];//创建一个视图
        headerView.backgroundColor=[UIColor whiteColor] ;
        UIImage* image = [UIImage imageNamed:@"ico_honor"] ;
        UIImageView* iconImage=[[UIImageView alloc]init] ;
        iconImage.image=image ;
        iconImage.contentMode=UIViewContentModeCenter;
        UILabel* label = [[UILabel alloc]init] ;
        label.text=@"荣誉榜";
        [headerView addSubview:label] ;
        [headerView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(10) ;
            make.centerY.equalTo(headerView.mas_centerY) ;
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY) ;
            make.left.equalTo(iconImage.mas_right).offset(10);
        }] ;
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 39, self.tableView.frame.size.width - 16, 0.5)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:lineLabel];
        return headerView ;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40 ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行",(long)indexPath.row);
    HonorModel* model =[_honorList objectAtIndex:indexPath.row] ;
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = model.userId;
    [self.navigationController pushViewController:person animated:YES] ;
    
}
@end
