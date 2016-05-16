//
//  RewardTableViewCell.m
//  colorRun
//
//  Created by engine on 15/11/11.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "RewardTableViewCell.h"

@implementation RewardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.getGit.backgroundColor = [Utile green];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) fillUiWithModel:(MyRewardModel *)modle{
    _title.text=modle.title ;
    _subtitle.text=modle.subTitle ;
    _nickName.text=modle.nickName ;
    _times.text=[NSString stringWithFormat:@"%@次",modle.times] ;
    _rank.text=[NSString stringWithFormat:@"%@/%@",modle.rank,modle.all] ;
    _pace.text=modle.pace ;
    _period.text=modle.period ;
    _bewrite.text=modle.bewrite ;
}
//点击领取
- (IBAction)getGift:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(didClickedGetGitButton:)]) {
        [self.delegate didClickedGetGitButton:self ];
    }
    
}

@end
