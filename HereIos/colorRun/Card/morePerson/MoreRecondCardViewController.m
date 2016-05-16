//
//  MoreRecondCardViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "MoreRecondCardViewController.h"
#import "RecordCardCell.h"
#import "DetailCardViewController.h"
@interface MoreRecondCardViewController ()
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation MoreRecondCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多推荐的卡片";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [Utile showHereView];
    _dataArray = [NSMutableArray array];
    self.pageNo = 1;
    [self getData];
}
-(void)refreshData{
    self.pageNo = 1;
    [self getData];
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getData];
    
}
-(void)getData{
    FindCardList* list = [[FindCardList alloc]init];
    list.findType = 0;
    list.pageNo = self.pageNo;
    list.pageSize = 10;
    [list executeHasParse:^(id jsonData) {
      // MoreCardList
        [self endFreshing];
        if (self.pageNo == 1) {
            [_dataArray removeAllObjects];
            for (id key in jsonData) {
                MoreCardList* card = [MoreCardList initWithJSON:key] ;
                [_dataArray addObject:card];
            }
            if (_dataArray.count < 10) {
                self.hasNext = NO;
            }
            else{
                self.hasNext = YES;
            }
            [self.tableView reloadData];
        }
        else{
            if ([jsonData isEqual:[NSNull null]]) {
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多了~~"];
                self.hasNext = NO;
            }
            else{
                for (id key in jsonData) {
                    MoreCardList* card = [MoreCardList initWithJSON:key] ;
                    [_dataArray addObject:card];
                }
                if (_dataArray.count%10==0) {
                    self.hasNext=YES ;
                }else{
                    self.hasNext=NO ;
                }
                [self.tableView reloadData];
            }
        }
    } failure:^(NSString *error) {
        [self endFreshing];
        [Utile showPromptAlertWithString:error];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *recordIdentifier = @"RecordCardCell";
    RecordCardCell * cell = [tableView dequeueReusableCellWithIdentifier:recordIdentifier];
    MoreCardList* card = [_dataArray objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCardCell" owner:self options:nil] firstObject];
    }
    RecommCardList * list = [[RecommCardList alloc]init];
    list.cardId = card.cardId;
    list.cardMode = card.cardMode;
    list.cardType = card.cardType;
    list.cardSource = card.cardSource;
    list.isPrize = card.isPrize;
    list.title = card.title;
    list.cardCount = card.cardCount;
    [cell fillContentWith:list];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreCardList* card = [_dataArray objectAtIndex:indexPath.row];
    DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
    de.cardId = card.cardId;
    de.cardType = card.cardType;
    [self.navigationController pushViewController:de animated:YES];
}
@end
