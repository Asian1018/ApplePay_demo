//
//  MoreHotCardViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "MoreHotCardViewController.h"
#import "HotCardCell.h"
#import "DetailCardViewController.h"
@interface MoreHotCardViewController ()
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation MoreHotCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多有热度的卡片";
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
    list.findType = 1;
    list.pageNo = self.pageNo;
    list.pageSize = 10;
    [list executeHasParse:^(id jsonData) {
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
//        [self.tableView reloadData];
    } failure:^(NSString *error) {
        [self endFreshing];
        [Utile showPromptAlertWithString:error];
    }];

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *hotIdentifier = @"HotCardCell";
    HotCardCell * cell = [tableView dequeueReusableCellWithIdentifier:hotIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreCardCell" owner:self options:nil] lastObject];
        
    }
    MoreCardList* card = [_dataArray objectAtIndex:indexPath.row];
    HotCardList * hot = [[HotCardList alloc]init];
    hot.cardId = card.cardId;
    hot.cardMode = card.cardMode;
    hot.cardType = card.cardType;
    hot.cardSource = card.cardSource;
    hot.title = card.title;
    hot.cardCount = card.cardCount;
    hot.cardSum = 2;
    [cell fillUIWith:hot];
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
