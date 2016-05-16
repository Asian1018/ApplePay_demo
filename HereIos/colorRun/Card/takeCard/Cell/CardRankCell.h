//
//  CardRankCell.h
//  colorRun
//
//  Created by zhidian on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

-(void)fillWithModel:(CardRankingList*)model indexpath:(NSIndexPath*)index;

@end
