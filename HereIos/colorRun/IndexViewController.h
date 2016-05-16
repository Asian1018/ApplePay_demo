//
//  IndexViewController.h
//  colorRun
//
//  Created by engine on 15/10/20.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JT3DScrollView.h"
#import "BaseViewController.h"
#import "UserDao.h"
#import "MyModel.h"
#import "CoolItemView.h"
//#import "ActivityDetailTableViewController.h"
@interface IndexViewController : BaseViewController<ItemClick>
-(void) getData ;
@end
