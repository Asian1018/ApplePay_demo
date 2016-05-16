//
//  HonorTableViewCell.m
//  colorRun
//
//  Created by engine on 15/11/25.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "HonorTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation HonorTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fillUiWithModel:(HonorModel *)model{
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2 ;
    _avatar.clipsToBounds=YES;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    _nickName.text=model.nickName ;
    if (![model.period isEqual:[NSNull null]]) {
       _time.text=model.period ;
    }
}
-(void) withIcon:(NSString *)image index:(NSInteger)index type:(NSInteger)type{
    if (type == 0) {
        //非竞技任务,不显示前三排名图标
        
        _numberLabel.text=[NSString stringWithFormat:@"%lu",index+1];
    }
    else{
    if (index<3) {
        UIImage* imageview = [UIImage imageNamed:image] ;
        _honorIcon.image=imageview ;
        _numberLabel.hidden=YES ;
    }else{

        _numberLabel.text=[NSString stringWithFormat:@"%lu",index+1] ;
//        _honorIcon.image = [UIImage imageNamed:@"honor_bg"];
    }
}
}
@end
