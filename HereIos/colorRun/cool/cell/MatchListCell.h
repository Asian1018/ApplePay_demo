//
//  MatchListCell.h
//  colorRun
//
//  Created by zhidian on 15/12/1.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchNameLabel;

@end
