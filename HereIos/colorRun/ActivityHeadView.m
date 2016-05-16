//
//  ActivityHeadView.m
//  colorRun
//
//  Created by engine on 15/11/24.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "ActivityHeadView.h"
#import "SDWebImage/UIImageView+WebCache.h"
@implementation ActivityHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)creatActivityHead{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"activity_detail_head" owner:nil options:nil];
    ActivityHeadView *view = [nibView objectAtIndex:0] ;
    return view ;
}
-(void) fillUiWhitActivityDetail:(ActivityDetail *)detail withActivityUser:(ActivityUser *)user{
    [_posterImage sd_setImageWithURL:[NSURL URLWithString:detail.subPoster]] ;
    _lastTime.text=detail.times ;
    _pepleCount.text=[NSString stringWithFormat:@"%lu",detail.count] ;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2 ;
    _avatar.clipsToBounds=YES;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    _nickName.text=user.nickName ;
    _bestTime.text=user.period ;
    _speed.text=user.pace ;
    _times.text=[NSString stringWithFormat:@"挑战%lu次",user.userCount] ;
}
@end
