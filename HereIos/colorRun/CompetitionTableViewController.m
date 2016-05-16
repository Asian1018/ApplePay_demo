//
//  CompetitionTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/13.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "CompetitionTableViewController.h"
#import "CompetitionTableViewCell.h"
#import "RDVTabBarController.h"
#import "CardDetailViewController.h"

@interface CompetitionTableViewController ()

@end

@implementation CompetitionTableViewController

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone ;
    _cardList= [NSMutableArray array] ;
    [self loadData:1] ;
    self.navigationItem.title=@"赛事卡券";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
-(void) refreshData{
   
    [self loadData:1] ;
}
-(void) loadNext{
    NSInteger currentPage =_api.pageNo ;
    [self loadData:currentPage+1] ;
}
-(void) loadData:(NSInteger) page{
    NSString * content = @"暂时还没有比赛卡劵呢~~~";
     _api = [[GetcardlistApi alloc]init];
    UserDao* dao = [UserDao sharedInstance];
    User* user = [dao loadUser];
    _api.userId = user.userId  ;
    _api.pageNo=page ;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [_api excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        [self endFreshing];
        hud.hidden = YES;
        NSString* code = [responseDate objectForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray* dataArray = [responseDate objectForKey:@"data"] ;
            if (![dataArray isEqual:[NSNull null]]) {
                if (page==1) {
                    _cardList=[NSMutableArray array] ;
                }
                for (id item in dataArray) {
                    MyCard* card = [[MyCard alloc]init] ;
                    for (NSString* key in [card PropertyKeys]) {
                        [card setValue:[item objectForKey:key] forKey:key] ;
                    }
                    _cardList=[_cardList arrayByAddingObject:card] ;
                }
//                [self loadEndWithContent:content imageName:nil] ;
                NSLog(@"cardList.count=%lu",_cardList.count) ;
                [self.tableView reloadData] ;
                if (dataArray.count%10==0) {
                    self.hasNext = YES ;
                }else{
                    self.hasNext = NO ;
                }
            }else{
                [self loadEndWithContent:content imageName:nil] ;
                self.hasNext = YES ;
            }
            
        }
        else{
            [Utile showPromptAlertWithString:@"网络请求出错"];
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        hud.hidden = YES;
        [self endFreshing];
        [self showErrorAlertWithString:@"系统出错,请稍后再试~~"];
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
    return _cardList.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"row=%lu count= %lu",indexPath.row,_cardList.count) ;
    MyCard* card = [_cardList objectAtIndex:indexPath.row] ;
    static NSString *CellIdentifier = @"my_competition";
    //自定义cell类
    CompetitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"competitioncell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell fillUiWithModel:card] ;
    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCard* card = [_cardList objectAtIndex:indexPath.row] ;
    CardDetailViewController * cardDteail = [[CardDetailViewController alloc]init];
    cardDteail.card = card;
    cardDteail.cardId = card.cardId;
    [self.navigationController pushViewController:cardDteail animated:YES];
    

}

@end
