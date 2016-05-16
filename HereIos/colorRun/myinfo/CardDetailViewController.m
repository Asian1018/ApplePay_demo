
#import "CardDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
@interface CardDetailViewController ()

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡劵详情";
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 300);
    view.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(CGRectGetMidX(view.frame) - 100, 40, 200, 200);
//    [imageView sd_setImageWithURL:[NSURL URLWithString:self.card.background]] ;
    imageView.image = [UIImage imageNamed:@"empty"];
    [view addSubview:imageView];
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, CGRectGetMaxY(imageView.frame) + 10, CGRectGetMaxX(self.tableView.frame) - 20, 40);
    label.text = @"入场参加赛事活动时请向工作人员出示该验票码";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    self.tableView.tableFooterView = view ;
    
    GetCarDetail * detail = [[GetCarDetail alloc]init];
    detail.cardId = self.cardId;
    detail.userId = [[UserDao sharedInstance]loadUser].userId ;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [detail excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        if ([responseDate[@"code"] isEqualToString:@"0"]) {
            NSDictionary * dic = responseDate[@"data"];
            for (NSString* key in [self.card PropertyKeys]) {
                [self.card setValue:[dic objectForKey:key] forKey:key] ;
            }
            
            NSString * str = dic[@"qrCode"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"empty"]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error.description];
    }];
    
    
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"my_competition";
    //自定义cell类
    CompetitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"competitioncell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [cell fillUiWithModel:_card] ;
    
    return cell;
}


@end
