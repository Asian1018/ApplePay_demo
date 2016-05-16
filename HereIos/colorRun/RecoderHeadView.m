//
//  RecoderHeadView.m
//  colorRun
//
//  Created by engine on 15/11/11.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "RecoderHeadView.h"

@implementation RecoderHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)createHeadView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"RewardHead" owner:nil options:nil];
    RecoderHeadView *view = [nibView objectAtIndex:0] ;
    view.frame=CGRectMake(0, 0, 600, 110) ;
    return view ;
}
//体现
- (IBAction)getCash:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(getMoneyAction)]) {
        [self.delegate getMoneyAction];
    }
}
//红包记录
- (IBAction)showMoneyDetailList:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showMyMoneyListAction)]) {
        [self.delegate showMyMoneyListAction];
    }
}

-(void) setRedPackageText:(NSString *)redPackage{
    if ([redPackage isEqual:[NSNull null]]) {
        redPackage = @"0";
    }
    _redPackage.text=[NSString stringWithFormat:@"%@元",redPackage];
}
@end
