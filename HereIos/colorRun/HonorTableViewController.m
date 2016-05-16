//
//  HonorTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/26.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "HonorTableViewController.h"
#import "Utile.h"
#import "Masonry.h"
#import "PersonInfoViewController.h"
@interface HonorTableViewController ()
@property(nonatomic,strong) ActivityhonorApi* api ;
@property(nonatomic,strong) NSMutableArray* array ;
@property(nonatomic,strong) ActivityUserHonorModel* model ;
@property(nonatomic,strong) NSArray* imageArray ;
//@property(nonatomic,strong) UILabel* sectionHead ;
@end

@implementation HonorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array=[NSMutableArray array] ;
    self.title = @"荣誉榜";
     _imageArray=@[@"honor_first",@"honor_second",@"honor_third",@""] ;
    [self getData:1];
    self.tableView.tableFooterView = [Utile showHereView];
}

-(void) getData:(NSInteger) page {
    _api = [[ActivityhonorApi alloc] init] ;
    User* user = [[UserDao sharedInstance] loadUser] ;
    if (user !=nil) {
        _api.userId=user.userId  ;
    }
    _api.pageNo=page ;
    _api.oaId=_oId ;
    _api.pageSize = 20;
    [_api executeHasParse:^(id jsonData) {
        [self parseUserHear:[jsonData objectForKey:@"activityUserHonor"]] ;
        [self parseHonorList:[jsonData objectForKey:@"activityHonorList"]] ;
    } failure:^(NSString *error) {
        [Utile showPromptAlertWithString:error.description];
    } ];
}

-(void) parseUserHear:(id) json{
    if ([json isEqual:[NSNull null]]) {
        return;
    }
    _model= [[ActivityUserHonorModel alloc]init] ;
    for (NSString* key  in [_model PropertyKeys]) {
        [_model setValue:[json objectForKey:key] forKey:key] ;
    }
    [self.tableView reloadData] ;
}

-(void) parseHonorList:(id) jsonArray{
    if ([jsonArray isEqual:[NSNull null]]) {
        return;
    }
    for (id item in jsonArray) {
        HonorModel* model = [[HonorModel alloc]init] ;
        for (NSString* key in [model PropertyKeys]) {
            [model setValue:[item objectForKey:key] forKey:key];
        }
        [_array addObject:model] ;
    }
    [self.tableView reloadData] ;
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
    return _array.count;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72 ;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48 ;
}
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headViewSection =[[UIView alloc]init] ;
    UILabel* rangeLabel=[[UILabel alloc]init] ;
    UILabel* timeLabel = [[UILabel alloc]init] ;
    headViewSection.backgroundColor=[Utile background] ;
    timeLabel.textColor = [Utile green];
    if (!_model) {
        rangeLabel.text = @"我当前排名:--";
        timeLabel.text = @"--";
    }
    else{
        if (![_model.sort isKindOfClass:[NSNull class]] &&_model.period ) {
            rangeLabel.text=[NSString stringWithFormat:@"我当前排名%@",_model.sort];
            timeLabel.text=_model.period ;
        }
    }
    if (_model.type == 0) {
         rangeLabel.text = @"我当前排名:--";
        if (_model.status == 0) {
            timeLabel.text = @"--";
        }
        else if (_model.type == 1){
            timeLabel.text = @"已挑战";
        }
    }
    [headViewSection addSubview:rangeLabel];
    [headViewSection addSubview:timeLabel] ;
    [rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headViewSection.mas_left).offset(8) ;
        make.centerY.equalTo(headViewSection.mas_centerY);
    }] ;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headViewSection.mas_right).offset(-8) ;
        make.centerY.equalTo(headViewSection.mas_centerY) ;
    }];
//    NSLog(@"section=%@",_model.sort) ;
    return headViewSection ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HonorModel* model =[_array objectAtIndex:indexPath.row] ;
//    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"activity_honor_cell";
    //自定义cell类
    HonorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"activity_cell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<_imageArray.count) {
        [cell withIcon:[_imageArray objectAtIndex:indexPath.row] index:indexPath.row type:model.type];
    }else {
        [cell withIcon:@"" index:indexPath.row type:model.type];
    }
    [cell fillUiWithModel:model] ;
    if (model.type == 0) {
        cell.time.text = @"已挑战";
    }
    else{
        cell.time.textColor = [Utile orange];
    }
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HonorModel* model = [_array objectAtIndex:indexPath.row];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"PersonInfo" bundle:[NSBundle mainBundle]];
    PersonInfoViewController *person = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([PersonInfoViewController class])] ;
    person.userId = model.userId;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:person animated:YES] ;

}

@end
