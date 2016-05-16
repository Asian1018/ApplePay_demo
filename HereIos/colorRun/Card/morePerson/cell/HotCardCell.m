//
//  HotCardCell.m
//  colorRun
//
//  Created by zhidian on 16/1/18.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "HotCardCell.h"

@implementation HotCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fillUIWith:(HotCardList*)list{
    switch (list.cardType) {
            //0:快捷1:图片2:计步3:跑步
        case 0:
            self.avatar.image = [UIImage imageNamed:@"card_punch"];
            break;
        case 1:
            self.avatar.image = [UIImage imageNamed:@"card_picture"];
            break;
        case 2:
            self.avatar.image = [UIImage imageNamed:@"card_steps"];
            break;
        case 3:
            self.avatar.image = [UIImage imageNamed:@"card_run"];
            break;
        default:
            break;
    }
    if (list.cardMode == 0) {
        self.titleImageView.image = [UIImage imageNamed:@"card_label_dong"];
    }
    self.contentLabel.text = list.title;
    self.countLabel.text = [NSString stringWithFormat:@"累计打卡%ld次",(long)list.cardSum];
    self.personLabel.text = [NSString stringWithFormat:@"%ld人参加",(long)list.cardCount];
    NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
    
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.countLabel.text];
    [changeText addAttributes:fontDict range:NSMakeRange(4,[NSString stringWithFormat:@"%ld",(long)list.cardSum].length)] ;
    self.self.countLabel.attributedText = changeText ;

    NSMutableAttributedString* personText = [[NSMutableAttributedString alloc]initWithString:self.personLabel.text];
    [personText addAttributes:fontDict range:NSMakeRange(0,[NSString stringWithFormat:@"%ld",(long)list.cardCount].length)] ;
    self.self.personLabel.attributedText = personText ;

}

@end
