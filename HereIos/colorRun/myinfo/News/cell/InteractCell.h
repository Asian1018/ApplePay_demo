//
//  InteractCell.h
//  colorRun
//
//  Created by zhidian on 16/2/2.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contendLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *personView;

-(void)fillUIWith:(InteractList*)model;
@end
