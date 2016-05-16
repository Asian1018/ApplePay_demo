//
//  TotalMileViewController.h
//  colorRun
//
//  Created by zhidian on 15/11/30.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalMileViewController : PageTableViewController
@property(nonatomic) NSInteger userId;
-(id)initWithUserId:(NSInteger)userId;
@end
