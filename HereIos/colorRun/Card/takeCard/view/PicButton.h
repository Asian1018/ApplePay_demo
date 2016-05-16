//
//  PicButton.h
//  colorRun
//
//  Created by zhidian on 16/1/21.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PicButton;
@protocol PicButtonDelegate <NSObject>
-(void)deletePicAction:(UIButton*)button;
@end

@interface PicButton : UIButton
@property(nonatomic,strong)UITapGestureRecognizer * tap;
@property(nonatomic,strong)UIButton *cancleButton;
@property(weak, nonatomic) id<PicButtonDelegate>delegate;
-(void)drawCancleButton;
-(void)addTaps;

@end
