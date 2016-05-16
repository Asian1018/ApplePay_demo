//
//  PageTableViewController.m
//  colorRun
//
//  Created by engine on 15/11/16.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "PageTableViewController.h"

@interface PageTableViewController ()

@end

@implementation PageTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _hasNext=[self needNext] ;
    _head= [SDRefreshHeaderView refreshView] ;
    [_head addToScrollView:self.tableView] ;
    [_head addTarget:self refreshAction:@selector(refreshData)] ;
    if (_hasNext) {
        _footView = [SDRefreshFooterView refreshView] ;
        [_footView addToScrollView:self.tableView] ;
        [_footView addTarget:self refreshAction:@selector(loadNextStart)] ;
    }
    self.tableView.tableFooterView = [Utile showHereView];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
-(BOOL) needNext{
    return YES ;
}
-(void)showErrorAlertWithString:(NSString *)string{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    

}
-(void) loadNextStart{
    if (_hasNext) {
        [self loadNext] ;
    }else{
//        [self loadEndWithContent:@"您还没参加过运动呢~~~" imageName:nil] ;
        [self endFreshing];
    }
}
-(void)endFreshing{
    if (self.head.refreshState==SDRefreshViewStateRefreshing) {
        [self.head endRefreshing] ;
    }
    if (self.footView.refreshState==SDRefreshViewStateRefreshing) {
        [self.footView endRefreshing] ;
    }
}
-(void)refreshData{}
-(void)loadNext{}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadEndWithContent:(NSString*)content imageName:(NSString*)name{
    
     WYEmptyTableFooterView * footerView = [WYEmptyTableFooterView emptyTableFooterViewWithTableView:self.tableView];
    footerView.placeholderLabel.text = content;
    if (name.length > 0) {
        footerView.playHolderImageView.image = [UIImage imageNamed:name];
    }
    self.tableView.tableFooterView = footerView;
    
    if (self.head.refreshState==SDRefreshViewStateRefreshing) {
        [self.head endRefreshing] ;
    }
    if (self.footView.refreshState==SDRefreshViewStateRefreshing) {
        [self.footView endRefreshing] ;
    }
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
