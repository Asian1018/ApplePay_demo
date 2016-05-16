//
//  RewardTableViewController.h
//  colorRun
//
//  Created by engine on 15/11/10.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
#import "RecoderHeadView.h" 
#import "CoolApi.h"
#import "SDRefresh.h"
#import "PageTableViewController.h"
#import "ResetPasswordViewController.h"
@interface RewardTableViewController : PageTableViewController
@property(nonatomic,strong) NSArray* rewardList ;
@property(nonatomic,strong) RecoderHeadView* headView ;
@property(nonatomic,strong) Getrewardlist* getRewardList ;


@end
