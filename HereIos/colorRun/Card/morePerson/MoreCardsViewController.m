//
//  MoreCardsViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/18.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "MoreCardsViewController.h"
#import "JXBAdPageView.h"
#import "RDVTabBarController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "HotCardCell.h"
#import "RecordCardCell.h"
#import "MoreRecondCardViewController.h"
#import "MoreHotCardViewController.h"
#import "DetailCardViewController.h"
@interface MoreCardsViewController ()<JXBAdPageViewDelegate>
{
    UIButton *moreHotButton;
    UIButton *moreRecButton;
}
@property(nonatomic,strong)JXBAdPageView * JXView;
@property(nonatomic,strong)NSMutableArray *recommendCardArray;
@property(nonatomic,strong)NSMutableArray *hotCardArray;

@end

@implementation MoreCardsViewController
-(void)dealloc{
    [self.JXView stopAds];
}
-(void)setHeaderScrolViewActionWithArray:(NSMutableArray*)array{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableHeaderView = headerView;
    //本地图片
//    _JXView = [[JXBAdPageView alloc] initWithFrame:headerView.frame];
//    _JXView.iDisplayTime = 2;
//    _JXView.delegate = self;
//    [_JXView startAdsWithBlock:@[@"interesting_card",@"interesting_person",@"movement",@"interesting_person"] block:^(NSInteger clickIndex){
//        NSLog(@"%d",(int)clickIndex);
//    }];
//    [headerView addSubview:_JXView];
    
      //  使用SDWebImage
        _JXView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120)];
        _JXView.contentMode = UIViewContentModeScaleAspectFill;
        _JXView.iDisplayTime = 2;
        _JXView.bWebImage = YES;
        _JXView.delegate = self;
    NSMutableArray * picarray = [NSMutableArray array];
    for (FocusCardList * list in array) {
        [picarray addObject:list.focusImg];
    }
    [_JXView startAdsWithBlock:picarray block:^(NSInteger clickIndex){
        FocusCardList * fo =[array objectAtIndex:clickIndex];
        NSLog(@"cardId = %ld",(long)fo.cardId);
        DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
        de.cardId = fo.cardId;
        de.cardType = fo.cardType;
        [self.navigationController pushViewController:de animated:YES];
        
    }];
    [headerView addSubview:_JXView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _recommendCardArray = [NSMutableArray array];
    _hotCardArray = [NSMutableArray array];
    self.title = @"更多有趣的卡片";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self getData];
}
-(void)getData{
    FindCard * find = [[FindCard alloc]init];
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [find executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        NSArray * focusCardList = jsonData[@"focusCardList"];
        NSArray * hotCardList = jsonData[@"hotCardList"];
        NSArray * recommendCardList = jsonData[@"recommendCardList"];
        NSMutableArray* focusCardArray = [NSMutableArray array];
        if (focusCardList.count > 0) {
            for (id key in focusCardList) {
                FocusCardList* card = [FocusCardList initWithJSON:key] ;
                [focusCardArray addObject:card];
            }
            [self setHeaderScrolViewActionWithArray:focusCardArray];
        }
        if (hotCardList.count > 0) {
            for (id key in hotCardList) {
                HotCardList* hot = [HotCardList initWithJSON:key] ;
                [_hotCardArray addObject:hot];
            }
        }
        if (recommendCardList.count > 0) {
            for (id key in recommendCardList) {
                RecommCardList* reco = [RecommCardList initWithJSON:key] ;
                [_recommendCardArray addObject:reco];
            }
        }
        if (recommendCardList.count == 0 && hotCardList.count == 0) {
            [Utile showEmptyViewWithView:self.tableView title:@"没有推荐的卡片~~" image:nil];
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    

}
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl {
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if (_recommendCardArray.count > 0) {
        count +=1 ;
    }
    if (_hotCardArray.count > 0) {
        count +=1 ;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_recommendCardArray.count > 3) {
            return 3;
        }
        else{
            return _recommendCardArray.count;
        }
    }
    if (section == 1) {
        if (_hotCardArray.count > 3) {
            return 3;
        }
        else{
            return _hotCardArray.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
    
}
-(void)showMoreCard:(UIButton*)button{
    if (button.tag == 1) {
        //推荐
        NSLog(@"推荐的卡片");
        MoreRecondCardViewController * more = [[MoreRecondCardViewController alloc]init];
        [self.navigationController pushViewController:more animated:YES];
        return;
    }
    MoreHotCardViewController * hot = [[MoreHotCardViewController alloc]init];
    [self.navigationController pushViewController:hot animated:YES];
    NSLog(@"有热度的卡片");
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(16, 10, 120, 40)];
//    la.textAlignment = NSTextAlignmentCenter;
    [view addSubview:la];
    if (section == 0) {
        if (_recommendCardArray.count > 3 ) {
//            if (!moreRecButton) {
                moreRecButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(view.frame) - 60, 10, 60, 40)];
                [moreRecButton setTitleColor:[Utile green] forState:UIControlStateNormal];
                [moreRecButton setTitle:@"更多" forState:UIControlStateNormal];
                [moreRecButton addTarget:self action:@selector(showMoreCard:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:moreRecButton];
                moreRecButton.tag = 1;
//            }
        }
    }
    if (section == 1) {
        if (_hotCardArray.count > 3) {
//            if (!moreHotButton) {
                moreHotButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(view.frame) - 60, 10, 60, 40)];
                [moreHotButton setTitleColor:[Utile green] forState:UIControlStateNormal];
                [moreHotButton setTitle:@"更多" forState:UIControlStateNormal];
                [moreHotButton addTarget:self action:@selector(showMoreCard:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:moreHotButton];
                moreHotButton.tag = 2;
//            }
        }
    }
    UILabel*  line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, CGRectGetWidth(view.frame), 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    UILabel * upline = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.frame), 10)];
    upline.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:upline];
    if (section == 0) {
        la.text = @"推荐的卡片";
        return view;
    }
        la.text = @"有热度的卡片";
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *recordIdentifier = @"RecordCardCell";
    static NSString *hotIdentifier = @"HotCardCell";
    if (indexPath.section == 0) {
        RecordCardCell * cell = [tableView dequeueReusableCellWithIdentifier:recordIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCardCell" owner:self options:nil] firstObject];
            
        }
        RecommCardList* list = [_recommendCardArray objectAtIndex:indexPath.row];
        [cell fillContentWith:list];
        
        return cell;
    }
    
    HotCardCell * cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCardCell" owner:self options:nil] lastObject];
    
    }
    HotCardList * card = [_hotCardArray objectAtIndex:indexPath.row];
    [cell fillUIWith:card];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RecommCardList* list = [_recommendCardArray objectAtIndex:indexPath.row];
        DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
        de.cardId = list.cardId;
        de.cardType = list.cardType;
        de.fromType = @"aa";
        [self.navigationController pushViewController:de animated:YES];
    }
    if (indexPath.section ==1) {
        HotCardList * card = [_hotCardArray objectAtIndex:indexPath.row];
        DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
        de.cardId = card.cardId;
        de.cardType = card.cardType;
        de.fromType = @"22";
        [self.navigationController pushViewController:de animated:YES];
    }
}


@end
