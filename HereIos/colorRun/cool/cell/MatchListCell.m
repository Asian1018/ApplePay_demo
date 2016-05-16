//
//  MatchListCell.m
//  colorRun
//
//  Created by zhidian on 15/12/1.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "MatchListCell.h"

@implementation MatchListCell

- (void)awakeFromNib {
    self.backGroundView.layer.cornerRadius = 1;
    self.backGroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backGroundView.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
