
#import "MyCardViewController.h"
#import "RDVTabBarController.h"
#import "MyCardCell.h"
@interface MyCardViewController ()<UIAlertViewDelegate>{
    BOOL canDelete;

}
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,strong)UIBarButtonItem * cancleButton;
@property(nonatomic,strong)UIBarButtonItem * deleteAllButton;
@property(nonatomic,strong)UIBarButtonItem *cancelBarButtonItem;
@property(nonatomic,strong)UIBarButtonItem *backIcon;
@property(nonatomic)NSInteger pageNo;
@end

@implementation MyCardViewController

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 22) {
        if (buttonIndex == 0) {
            //quxiao
            [self dismisss];
        }
        else{
            NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
            // 是否删除特定的行
            BOOL deleteSpecificRows = selectedRows.count > 0;
            // 删除特定的行
            if (deleteSpecificRows)
            {
                // 将所选的行的索引值放在一个集合中进行批量删除
                NSMutableIndexSet *indicesOfItemsToDelete = [NSMutableIndexSet new];
                NSMutableArray * arr = [NSMutableArray array];
                for (NSIndexPath *selectionIndex in selectedRows)
                {
                    [indicesOfItemsToDelete addIndex:selectionIndex.row];
                    MyCardListModel* card = [_dataArray objectAtIndex:selectionIndex.row];
                    [arr addObject:[NSNumber numberWithInteger:card.qcId]];
                }
                NSLog(@"得到的数组:%@",arr);
                DeleteCard * delete = [[DeleteCard alloc]init];
                delete.qcIds = [Utile changeToJsonStringWith:arr];
                MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
                [delete executeHasParse:^(id jsonData) {
                    hud.hidden = YES;
                    if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                        //成功删除
                        // 从数据源中删除所选行对应的值
                        [self.dataArray removeObjectsAtIndexes:indicesOfItemsToDelete];
                        
                        //删除所选的行
                        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationTop];
                        [Utile showWZHUDWithView:self.navigationController.view andString:@"删除卡片成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
                        
                    }
                    else{
                        [Utile showWZHUDWithView:self.navigationController.view andString:@"删除失败"];
                    }
                } failure:^(NSString *error) {
                    hud.hidden = YES;
                    [Utile showPromptAlertWithString:error];
                }];
            }
            else
            {
                // 删除全部
                [self.dataArray removeAllObjects];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [self.tableView setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = self.cancleButton;
            self.navigationItem.leftBarButtonItem = self.backIcon;
        
        }
    }

}
-(void)deleteAllCell{
    if ([self.deleteAllButton.title isEqualToString:@""]) {
        NSLog(@"啥都没选择");
        return;
    }
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除卡片也会退出卡片 卡片之后不会出现在“我的卡片”" delegate:self cancelButtonTitle:@"好,再想想" otherButtonTitles:@"恩,就是要这样", nil];
    alert.tag = 22;
    [alert show];
    
}
-(void)dismisss{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.cancleButton;
    self.navigationItem.leftBarButtonItem = self.backIcon;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的卡片";
    self.pageNo = 1;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    _dataArray = [NSMutableArray array];
    [self getCardData];
    self.cancleButton = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(cancleCardCell)];
    self.navigationItem.rightBarButtonItem = self.cancleButton;
    canDelete = NO;
    self.deleteAllButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllCell)];
     self.cancelBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismisss)];
    self.backIcon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_black_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.tableView.tableFooterView = [Utile showHereView];
}
-(void) updateBarButtons
{
    
    if (self.tableView.allowsSelectionDuringEditing == YES) {
        
        self.navigationItem.leftBarButtonItems = nil;
        
        self.navigationItem.leftBarButtonItem = self.deleteAllButton;
        self.deleteAllButton.title = @"";
        self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
        
        return;
    }

}
-(void)cancleCardCell{
    [self.tableView setEditing:YES animated:YES];
    [self updateBarButtons];
}
-(void)refreshData{
    self.pageNo = 1;
    [self getCardData];
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getCardData];
    
}
-(void)getCardData{
    User* user = [[UserDao sharedInstance]loadUser] ;
    GetUserCard * card = [[GetUserCard alloc]init];
    card.pageNo = self.pageNo;
    card.pageSize = 10;
    card.userId = user.userId ;
    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
    [card executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        [self endFreshing];
        if (self.pageNo == 1) {
            [_dataArray removeAllObjects];
            if ([jsonData isEqual:[NSNull null]]) {
                self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"噗~~~还没有任何卡片" image:nil];
                self.navigationItem.rightBarButtonItem = nil;
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
                    [_dataArray addObject:card];
                }
                if (_dataArray.count < 10) {
                    self.hasNext = NO ;
                }
                else{
                    self.hasNext = YES ;
                }
                [self.tableView reloadData];
            }
        }
        else{
            //加载更多
            if ([jsonData isEqual:[NSNull null]]) {
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                self.hasNext = NO;
            }
            else{
                for (id item in jsonData) {
                    MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
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
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
    
    
//    GetUserCard * card = [[GetUserCard alloc]init];
//    card.pageNo = self.pageNo;
//    card.pageSize = 10;
//    card.userId = [[UserDao sharedInstance]loadUser].userId ;
//    MBProgressHUD * hud = [Utile showHudInView:self.tableView];
//    [card executeHasParse:^(id jsonData) {
//        hud.hidden = YES;
//        NSLog(@"结果:%@",jsonData);
//        if ([jsonData isEqual:[NSNull null]]) {
//            self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"噗~~~还没有任何卡片" image:nil];
//            self.navigationItem.rightBarButtonItem = nil;
//        }
//        else{
//            [_dataArray removeAllObjects];
//            for (id item in jsonData) {
//                MyCardListModel* card = [MyCardListModel initWithJSON:item] ;
//                [_dataArray addObject:card];
//            }
//            [self.tableView reloadData];
//        }
//        
//    } failure:^(NSString *error) {
//        hud.hidden = YES;
//        [Utile showPromptAlertWithString:error];
//    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indent = @"MyCardCell";
    //自定义cell类
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    MyCardListModel* card = [_dataArray objectAtIndex:indexPath.row];
    MyCardCell * cell = [tableView dequeueReusableCellWithIdentifier:indent];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MycardCell" owner:self options:nil] lastObject];
//        cell.delegate = self;
        cell.titleLabel.tag = indexPath.row;
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [cell fillCellWithModel:card];
    cell.signCardButton.hidden = YES;
    
    return cell;
}

#pragma mark - 编辑
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// 是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}
// 编辑模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    
}

// 选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"您点击了第%ld分区第%ld行",(long)indexPath.section, (long)indexPath.row);
    [self updateDeleteButtonTitle];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the delete button's title based on how many items are selected.
    [self updateDeleteButtonTitle];
}

-(void)updateDeleteButtonTitle
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
//    BOOL allItemsAreSelected = selectedRows.count == self.dataArray.count;
    
    BOOL noItemsAreSelected = selectedRows.count == 0;
    //allItemsAreSelected || noItemsAreSelected
    if (noItemsAreSelected) {
        self.deleteAllButton.title = @"";
        }
    else {
        self.deleteAllButton.title = [NSString stringWithFormat:@"删除 (%lu)", (unsigned long)selectedRows.count];
    }
    
}

@end
