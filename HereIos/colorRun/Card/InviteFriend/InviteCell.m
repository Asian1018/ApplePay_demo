//
//  InviteCell.m
//  colorRun
//
//  Created by zhidian on 16/1/28.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "InviteCell.h"

@implementation InviteCell{
    GroupList* myList;

}

- (void)awakeFromNib {
    [self.choiceButton setImage:[UIImage imageNamed:@"button_choice_press"] forState:UIControlStateDisabled];
    [self.choiceButton setImage:[UIImage imageNamed:@"button_choice_normal"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choiceAction:(id)sender {
//    self.choiceButton.selected = !self.choiceButton.selected;
    if ([self.delegate respondsToSelector:@selector(choosePersonAction:cell:)]) {
        [self.delegate choosePersonAction:myList cell:self];
    }
}


-(void)setUIWith:(GroupList *)list{
    if (list.isShow == YES) {
        self.choiceButton.enabled = NO;
    }
    else{
        self.choiceButton.enabled = YES;
        
    }
    myList = list;
    self.nameLabel.text = list.nickName;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:list.avatar] placeholderImage:nil];
    
}
@end
