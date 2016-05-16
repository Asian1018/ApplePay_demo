//
//  MySportTableViewController.h
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoolApi.h"
#import "UserDao.h"
#import "MyModel.h"
#import "PageTableViewController.h"
@interface MySportTableViewController : PageTableViewController
@property(nonatomic,strong) NSMutableDictionary *dataDict ;
@property(nonatomic,strong) NSMutableArray* groupArray ;
@property(nonatomic,strong) Getrecordlist* getRecordListApi;
@end
