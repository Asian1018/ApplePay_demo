//
//  MineViewController.h
//  colorRun
//
//  Created by engine on 15/10/22.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDao.h"
#import "CoolApi.h"
#import "RewardTableViewController.h"
@interface MineViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *signe;
@property (weak, nonatomic) IBOutlet UILabel *kilometers;
@property (weak, nonatomic) IBOutlet UILabel *periods;
@property (nonatomic,strong) UserDao* dao ;
@property (weak, nonatomic) IBOutlet UIView *myHeagerView;
@property (weak, nonatomic) IBOutlet UILabel *focusPerson;
@property (weak, nonatomic) IBOutlet UILabel *focusValue;

@property (weak, nonatomic) IBOutlet UILabel *mileLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLoginLabel;
@property (weak, nonatomic) IBOutlet UIView * myFooterView;

-(void) getUserInfo:(NSInteger) userId;
@end
