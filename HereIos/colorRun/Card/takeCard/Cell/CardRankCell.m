//
//  CardRankCell.m
//  colorRun
//
//  Created by zhidian on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "CardRankCell.h"
#import "UIImageView+WebCache.h"

@implementation CardRankCell

- (void)awakeFromNib {
    self.avatar.layer.cornerRadius = 22 ;
    self.avatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fillWithModel:(CardRankingList*)model indexpath:(NSIndexPath *)index{
    self.nameLabel.text = model.nickName;
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)index.row + 1];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    self.dayLabel.text = [NSString stringWithFormat:@"坚持%ld天",(long)model.days];
    
    NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.dayLabel.text];
    [changeText addAttributes:fontDict range:NSMakeRange(2,self.dayLabel.text.length - 3)] ;
    self.dayLabel.attributedText = changeText;
    
    if (index.row == 0) {
        //第一个cell day字体变大突出
        NSDictionary* fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[Utile orange]} ;
        NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.dayLabel.text];
        [changeText addAttributes:fontDict range:NSMakeRange(2,self.dayLabel.text.length - 3)] ;
        self.dayLabel.attributedText = changeText;
    }
}
@end
