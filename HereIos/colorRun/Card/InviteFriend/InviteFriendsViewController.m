
#import "InviteFriendsViewController.h"
#import "InviteCell.h"
#import "ChineseString.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "NotNotiViewController.h"
#import "UMSocial.h"
@interface InviteFriendsViewController ()<InviteCellDelegate>{
    UILabel * la;
}
@property(nonatomic,strong) NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)NSMutableArray * chooseArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *LetterResultArr;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UILabel *playHolderLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property(nonatomic,strong) NSMutableArray * lastArray;
@property(nonatomic,strong) UIBarButtonItem * rightButton;
@end

@implementation InviteFriendsViewController
//改变选中的view
-(void)changeHeaderChooseView{
    CGFloat margent = 8;
    CGFloat width = 40;
    self.lastArray = [NSMutableArray array];
    [self.playHolderLabel removeFromSuperview];
    for (UIButton * bu in self.chooseView.subviews) {
        [bu removeFromSuperview];
    }
    if (self.chooseArray.count == 0) {
        la = [[UILabel alloc]init];
        la.frame = CGRectMake(16, 18, 100, 18);
        la.font = [UIFont systemFontOfSize:15];
        la.text = @"未选中的逗比";
        la.textColor = [UIColor lightGrayColor];
        [self.headerView addSubview:la];
        self.rightButton.enabled = NO;
        return;
    }
    for (int i = 0; i < self.chooseArray.count; i++) {
        UIButton * bu = [[UIButton alloc]init];
        GroupList * list  = [self.chooseArray objectAtIndex:i];
        [self.lastArray addObject:[NSNumber numberWithInteger:list.userId]];
        bu.frame = CGRectMake(width *i +((i +1)* margent), 8, width, width);
        bu.tag = i;
        bu.layer.cornerRadius = width /2 ;
        bu.clipsToBounds = YES;
        [bu sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",list.avatar]] forState:UIControlStateNormal];
        [bu addTarget:self action:@selector(cancleChoosePerson:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:bu];
    }
    self.rightButton.enabled = YES;
    [la removeFromSuperview];
    NSLog(@"得到的字符串数组:%@",self.lastArray);
}
-(void)cancleChoosePerson:(UIButton*)button{
    NSInteger index = button.tag;
    GroupList * list  = [self.chooseArray objectAtIndex:index];
    for (int i = 0; i < self.LetterResultArr.count; i ++) {
        NSArray * arr = [self.LetterResultArr objectAtIndex:i];
        for (int x = 0; x < arr.count; x++) {
            if ([list.nickName isEqualToString:[arr objectAtIndex:x]]) {
                InviteCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:i]];
                cell.choiceButton.enabled = YES;
            }
        }
        
        
    }
    for (GroupList * lists in _dataArray) {
        if ([lists.nickName isEqualToString:list.nickName]) {
            lists.isShow = NO;
            break;
        }
    }
    [self.chooseArray removeObjectAtIndex:index];
    [self changeHeaderChooseView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"叫逗比来战痛";
    self.tableView.tableFooterView = [Utile showHereView];
    _dataArray = [NSMutableArray array];
    self.chooseArray = [NSMutableArray array];
    [self getData];
    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(handUp)];
    self.rightButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
}
-(void)backView{
    if (self.fromType.length > 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)handUp{
    CardInvite * card = [[CardInvite alloc]init];
    card.users = [Utile changeToJsonStringWith:self.lastArray];
    card.userId = [[UserDao sharedInstance]loadUser].userId;
    card.cardId = self.cardId;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [card executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
            //成功
            [Utile showWZHUDWithView:self.navigationController.view andString:@"刚刚告诉逗比了..."];
            if ([self.delegate respondsToSelector:@selector(choosenFrindsCount:)]) {
                [self.delegate choosenFrindsCount:self.lastArray.count];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [Utile showWZHUDWithView:self.navigationController.view andString:@"邀请逗比没成功~"];
        }
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
}
-(void)getData{
    GroupListApi * api = [[GroupListApi alloc]init];
    api.userId = [[UserDao sharedInstance]loadUser].userId;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    self.headerView.hidden = YES;
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        self.headerView.hidden = NO;
        NSLog(@"得到的数组结果:%@",jsonData);
        NSMutableArray * personArray = [NSMutableArray array];
        for (id item in jsonData) {
            GroupList * list = [GroupList initWithJSON:item];
            list.isShow = NO;
            [_dataArray addObject:list];
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
#pragma InviteCellDelegate

-(void)choosePersonAction:(GroupList *)list cell:(InviteCell *)cell{
    if (self.chooseArray.count > 5) {
        [Utile showWZHUDWithView:self.tableView andString:@"最多只能选6个人喔~"];
        return;
    }
    for (GroupList * lists in _dataArray) {
        if ([lists.nickName isEqualToString:list.nickName]) {
            lists.isShow = YES;
            break;
        }
    }
    
    cell.choiceButton.enabled = NO;
    [self.chooseArray addObject:list];
    NSLog(@"选中%@",list.nickName);
    
    [self changeHeaderChooseView];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [_indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.LetterResultArr objectAtIndex:section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
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
    static NSString * cellInd = @"InviteCell";
    InviteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInd];
    GroupList * list = [[GroupList alloc]init];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteCell" owner:self options:nil] lastObject];
        cell.choiceButton.tag = indexPath.row;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.nameLabel.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    for (GroupList * lists in _dataArray) {
        if ([lists.nickName isEqualToString:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]) {
            list = lists;
            break;
        }
    }
    
    [cell setUIWith:list];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"---->%@",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]);
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                    message:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]
//                                                   delegate:nli
//                                          cancelButtonTitle:@"YES" otherButtonTitles:nil];
////    [alert show];
//    GroupList * list = [[GroupList alloc]init];
//    for (GroupList * lists in _dataArray) {
//        if ([lists.nickName isEqualToString:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]) {
//            list = lists;
//            break;
//        }
//    }
//    NSLog(@"点击了%ld",(long)list.userId);
    
//    InviteCell *cell = [tableView cellForRowAtIndexPath:indexPath;]
//    cell.choiceButton.selected = YES;
}
/**
 [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
 [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
 [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
 [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
 [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.shareUrl;
 *
 */
-(void)setURLAction{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"Here又有好玩的咯！";
    [UMSocialData defaultData].extConfig.qqData.title = @"Here又有好玩的咯！";
}

-(void)shareActionWithArray:(NSArray*)array{
    UIImage * image= [UIImage imageNamed:@"cool_ico"];
    [self setURLAction];
    NSString * str = @"我在Here发现一个好玩66的卡片，来，加入进来一起玩~#Here#";
    if ([array isEqual:@[UMShareToSina]]) {
        str =[NSString stringWithFormat:@"我在Here发现一个好玩66的卡片，来，加入进来一起玩~~%@",self.shareUrl];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:array
                                                        content:str
                                                          image:image
                                                       location:nil
                                                    urlResource:nil
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response){
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             if ([array isEqual:@[UMShareToSina]]) {
                                                                 [Utile showWZHUDWithView:self.navigationController.view andString:@"分享成功,请查看您的新浪微博"];
                                                             }
                                                         }
                                                     }];

}
- (IBAction)shareWeixin:(id)sender {
     NSLog(@"分享到微信");
    [self shareActionWithArray:@[UMShareToWechatSession]];
    
}

- (IBAction)shareQQ:(id)sender {
   NSLog(@"分享到QQ");
    [self shareActionWithArray:@[UMShareToQQ]];
}

- (IBAction)shareSina:(id)sender {
    NSLog(@"分享到新浪微博");
    [self shareActionWithArray:@[UMShareToSina]];
     
}
- (IBAction)showNotiPerson:(id)sender {
    NotNotiViewController * noti = [[NotNotiViewController alloc]init];
    noti.title = @"未关注的逗比";
    [self.navigationController pushViewController:noti animated:YES];
    
}
@end
