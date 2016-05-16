
#import "MorePersonsViewController.h"
#import "HonorTableViewCell.h"
#import "RDVTabBarController.h"
#import "CardRankCell.h"
#import "PersonInfoViewController.h"
@interface MorePersonsViewController ()
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic)NSInteger pageNo;
@end

@implementation MorePersonsViewController
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多有意思的人";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [Utile showHereView];
    self.pageNo = 1;
    [self getdata];
    
}
-(void)refreshData{
    self.pageNo = 1;
    [self getdata];
}

-(void) loadNext{
    self.pageNo = self.pageNo + 1;
    [self getdata];
    
}
-(void)getdata{
    FindCardUser * find = [[FindCardUser alloc]init];
    find.pageNo = self.pageNo;
    find.pageSize = 20;
    MBProgressHUD* hud = [Utile showHudInView:self.tableView];
    [find executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        [self endFreshing];
        if (self.pageNo ==1) {
            [self.dataArray removeAllObjects];
            if ([jsonData isEqual:[NSNull null]]) {
                self.tableView.tableFooterView = [Utile showEmptyViewWithView:self.tableView title:@"更多有意思的人还没上路" image:nil];
                self.hasNext = NO;
                return ;
            }
            for (id team in jsonData) {
                CardRankingList * list = [CardRankingList initWithJSON:team];
                [_dataArray addObject:list];
            }
            if (_dataArray.count < 20) {
                self.hasNext = NO;
            }
            else{
                self.hasNext = YES;
            }
            [self.tableView reloadData];
        }
        else{
            if ([jsonData isEqual:[NSNull null]]) {
                [Utile showWZHUDWithView:self.tableView andString:@"没有更多啦~~"];
                self.hasNext = NO;
                return ;
            }
            else{
                for (id team in jsonData) {
                    CardRankingList * list = [CardRankingList initWithJSON:team];
                    [_dataArray addObject:list];
                }
                if (_dataArray.count%20==0) {
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


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CardRankCell";
    //自定义cell类
    CardRankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CardRankCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CardRankingList * list = [_dataArray objectAtIndex:indexPath.row];
    [cell fillWithModel:list indexpath:indexPath];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CardRankingList * list = [_dataArray objectAtIndex:indexPath.row];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = list.userId;
    [self.navigationController pushViewController:person animated:YES] ;
}

@end
