//
//  CoolItemView.m
//  colorRun
//
//  Created by engine on 15/10/22.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "CoolItemView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CoolApi.h"

@implementation CoolItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(CoolItemView* ) initCoolItemView:(CGRect) rect{
//    CoolItemView* view = [[CoolItemView alloc]initWithFrame:rect] ;
//    view.backgroundColor=[UIColor redColor] ;
//
//    return view ;
    
        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil];
        CoolItemView *view = [nibView objectAtIndex:0] ;
    view.backgroundColor = [Utile background];
    view.frame=rect ;
//    view.bottomViewHeight.constant=rect.size.height/2.618 ;
//    view.firstMargTop.constant=view.bottomViewHeight.constant*0.125 ;
//    view.lastLabelMargin.constant=view.bottomViewHeight.constant*0.062 ;
    return view ;
    
}
- (IBAction)getChallenge:(UIButton *)sender {
 
    if ([self.delegate respondsToSelector:@selector(onActivityClick:)]) {
        [self.delegate onActivityClick:_activity] ;
    }
    }

+(CoolItemView*) initCoolItemView:(CGRect)rect whithModel:(Activity*) model{
    CoolItemView *item = [self initCoolItemView:rect] ;
    UIImage *postImage = [UIImage imageNamed:model.poster] ;
    item.activity=model ;
    [item.bgImage sd_setImageWithURL:[NSURL URLWithString:model.poster]] ;
    item.bgImage.image=postImage ;
    switch (model.status) {
        case 2:
            [item.joinButton setTitle:@"挑战成功" forState:UIControlStateNormal];
            break;
        case 3:
            [item.joinButton setTitle:@"挑战成功" forState:UIControlStateNormal];
            break;
        case 5:
            [item.joinButton setTitle:@"任务已结束" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    return item ;
}

@end
