//
//  CompetitionTableViewCell.m
//  colorRun
//
//  Created by engine on 15/11/13.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "CompetitionTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
@implementation CompetitionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) fillUiWithModel:(MyCard *)card{
    _title.text= card.title ;
    _startTime.text=card.startTime ;
    _address.text=card.address ;
    if (card.status==0) {
        UIImage* imageView = [UIImage imageNamed:@"card_unbegun"] ;
        _status.image=imageView ;
    }else if(card.status==1){
        UIImage* imageView = [UIImage imageNamed:@"card_conduct"] ;
        _status.image=imageView ;
    }else{
        UIImage* imageView = [UIImage imageNamed:@"card_overdue"] ;
        _status.image=imageView  ;
    }
    [_backgound sd_setImageWithURL:[NSURL URLWithString:card.background]] ;
}
@end
