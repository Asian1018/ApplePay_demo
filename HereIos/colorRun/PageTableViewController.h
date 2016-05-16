//
//  PageTableViewController.h
//  colorRun
//
//  Created by engine on 15/11/16.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
@interface PageTableViewController : UITableViewController
@property(nonatomic,strong) SDRefreshHeaderView* head  ;
@property(nonatomic,strong) SDRefreshFooterView* footView  ;
@property(nonatomic,assign) BOOL hasNext  ;
-(void) refreshData ;
-(void) loadNext  ;
-(void) loadEndWithContent:(NSString*)content imageName:(NSString*)name;
-(void)showErrorAlertWithString:(NSString*)string;
-(void)endFreshing;
-(BOOL) needNext ;

@end
