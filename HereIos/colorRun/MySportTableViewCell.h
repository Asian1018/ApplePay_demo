//
//  MySportTableViewCell.h
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface MySportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *runType;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *activityType;
@property (weak, nonatomic) IBOutlet UILabel *kilometer;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *pace;
-(void) fillUiWithMode:(MySport*) sport ;
@end
