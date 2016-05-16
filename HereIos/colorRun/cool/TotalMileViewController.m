//
//  TotalMileViewController.m
//  colorRun
//
//  Created by zhidian on 15/11/30.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "TotalMileViewController.h"
#import "MyCardCell.h"
#import "DetailCardViewController.h"
@interface TotalMileViewController ()<MyCardCellDelegate>{

}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation TotalMileViewController
-(id)initWithUserId:(NSInteger)userId{
        if (self = [super init]) {
            self.userId = userId;
        }
        
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
//    self.tableView.backgroundColor = [UIColor yellowColor];
    self.pageNo = 1;
    [self getdata];

}
-(void)signCardAction:(MyCardCell*)cell{


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
    GetUserCard * card = [[GetUserCard alloc]init];
    card.pageNo = self.pageNo;
    card.pageSize = 10;
    card.userId = self.userId ;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [card executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        [self endFreshing];
        if (self.pageNo == 1) {
            [_dataArray removeAllObjects];
            if ([jsonData isEqual:[NSNull null]]) {
                self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"还没创建过卡片喔" image:nil];
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
                    if (card.broadcast == 0) {
                        [_dataArray addObject:card];
                    }
                }
                if (self.dataArray.count < 10) {
                    if (_dataArray.count == 0) {
                        self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"还没创建过卡片喔" image:nil];
                    }
                    self.hasNext = NO;
                }
                else{
                    self.hasNext = YES;
                }
            }
            [self.tableView reloadData];
        }
        else{
            if ([jsonData isEqual:[NSNull null]]) {
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
                    if (card.broadcast == 0) {
                        [_dataArray addObject:card];
                    }
                }
                if (_dataArray.count %10 == 0) {
                    self.hasNext = YES;
                }
                else{
                    self.hasNext = NO;
                }
            }
            [self.tableView reloadData];
        
        }
    } failure:^(NSString *error) {
        [self endFreshing];
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *indent = @"MyCardCell";
    //自定义cell类
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    MyCardListModel* card = [_dataArray objectAtIndex:indexPath.row];
    MyCardCell * cell = [tableView dequeueReusableCellWithIdentifier:indent];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MycardCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        cell.titleLabel.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    [cell fillCellWithModel:card];
    cell.signCardButton.hidden = YES;
    cell.typeLabel.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCardListModel* card = [_dataArray objectAtIndex:indexPath.row];
    DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
    de.cardId = card.cardId;
    de.cardType = card.cardType;
    de.fromType = @"1";
    [self.navigationController pushViewController:de animated:YES];
    
}


@end
