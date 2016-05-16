//
//  MatchListViewController.m
//  colorRun
//
//  Created by zhidian on 15/11/30.
//  Copyright © 2015年 engine. All rights reserved.
//
#import "ActivityDetailTableViewController.h"
#import "MatchListViewController.h"
#import "MatchListCell.h"
#import "BurningModel.h"
#import "O2OWebViewController.h"
@interface MatchListViewController ()<UITableViewDelegate,UITableViewDataSource>{
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation MatchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.pageNo = 1;
    [self getdata];
//    self.tableView.backgroundColor = [UIColor blueColor];
}
-(void) refreshData{
    self.pageNo = 1;
    [self getdata] ;
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getdata] ;
}

-(void)getdata{
    OtherSportList * list = [[OtherSportList alloc]init];
    list.userId = self.userId;
    list.pageNo = self.pageNo;
    list.pageSize = 10;
    [list excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        [self endFreshing];
        NSString * code = responseDate[@"code"];
        if ([code isEqualToString:@"0"]) {
            //succ
            NSArray * arr = responseDate[@"data"];
            NSLog(@"得到list的数目:%lu",(unsigned long)arr.count);
            if (self.pageNo == 1) {
                [_dataArray removeAllObjects];
                if (arr.count == 0) {
                    WYEmptyTableFooterView * empty = [WYEmptyTableFooterView emptyTableFooterViewWithTableView:self.tableView];
                    empty.placeholderLabel.text = @"这小伙伴好懒,还没参加赛事活动";
                    self.tableView.tableFooterView = empty;
                    self.hasNext = NO;
                    return ;
                }
                for (id list in arr) {
                    OtherPersonListModel* model= [[OtherPersonListModel alloc]init] ;
                    for (id key in [model PropertyKeys]) {
                        [model setValue:[list objectForKey:key] forKey:key] ;
                    }
                    [self.dataArray addObject:model] ;
                }
                if (self.dataArray.count < 10) {
                    self.hasNext = NO;
                }
                else{
                    self.hasNext = YES;
                }
                [self.tableView reloadData];
            }
            else{
                if (arr.count == 0) {
                    [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                    self.hasNext = NO;
                    return ;
                }
                for (id list in arr) {
                    OtherPersonListModel* model= [[OtherPersonListModel alloc]init] ;
                    for (id key in [model PropertyKeys]) {
                        [model setValue:[list objectForKey:key] forKey:key] ;
                    }
                    [self.dataArray addObject:model] ;
                }
                if (_dataArray.count %10 == 0) {
                    self.hasNext = YES;
                }
                else{
                    self.hasNext = NO;
                }
                [self.tableView reloadData];
            }
        }
        else{
            [Utile showPromptAlertWithString:@"请求出错，请稍后再试"];
        
        }
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        [self endFreshing];
        [Utile showPromptAlertWithString:error.description];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OtherPersonListModel * model = [self.dataArray objectAtIndex:indexPath.row];
    static NSString * CellIdentifier = @"match_list";
    MatchListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"matchListCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Configure the cell...
    cell.matchNameLabel.text = model.title;
    cell.joinTimeLabel.text = [NSString stringWithFormat:@"%@加入",model.joinTime];
    cell.startTimeLabel.text = model.startTime;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    NSLog(@"点击了%ldCell",(long)indexPath.row);
     OtherPersonListModel * model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.type==2) {
        ActivityDetailTableViewController* controller = [[ActivityDetailTableViewController alloc]init];
        controller.aId=model.activityId ;
        [self.navigationController pushViewController:controller animated:YES] ;
    }else if(model.type == 1){
        NSLog(@"o2o活动");
        O2OWebViewController * web = [[O2OWebViewController alloc]init];
        if (model.o2oUrl.length > 0) {
            web.o2oUrl = model.o2oUrl;
            [self.navigationController pushViewController:web animated:YES];
            //            [Utile showWZHUDWithView:self.navigationController.view andString:@"这是O2O活动"];
            return;
        }
        [Utile showWZHUDWithView:self.navigationController.view andString:@"这是O2O活动,没取到地址"];
    }else{
        NSLog(@"未知类型=%lu",model.type) ;
    }

}

@end
