//
//  CompetitionTableViewController.h
//  colorRun
//
//  Created by engine on 15/11/13.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDao.h"
#import "MyModel.h"
#import "CoolApi.h"
#import "PageTableViewController.h"
#import "CoolApi.h"
@interface CompetitionTableViewController : PageTableViewController
@property(nonatomic,strong) NSArray* cardList ;
@property(nonatomic,strong) GetcardlistApi* api ;
@end
