//
//  ActivityDetailTableViewController.h
//  colorRun
//
//  Created by engine on 15/11/24.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityHeadView.h"
#import "CoolApi.h"
#import "PageTableViewController.h"
@interface ActivityDetailTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changleButton;

@property(nonatomic,assign) NSInteger aId  ;
@end
