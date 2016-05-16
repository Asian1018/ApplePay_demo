//
//  PicButton.m
//  colorRun
//
//  Created by zhidian on 16/1/21.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "PicButton.h"
#import "SJAvatarBrowser.h"

@implementation PicButton

-(void)drawCancleButton{
    self.cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20, 0, 20, 20)];
    [self addSubview:self.cancleButton];
    self.cancleButton.tag = self.tag;
    [self.cancleButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addTaps];
}

-(void)deleteButton:(UIButton*)button{
    [_cancleButton removeFromSuperview];
    _cancleButton = nil;
    [self setImage:nil forState:UIControlStateNormal];
    [self removeGestureRecognizer:_tap];
    if ([self.delegate respondsToSelector:@selector(deletePicAction:)]) {
        [self.delegate deletePicAction:self];
    }
    
}

-(void)addTaps{
    _tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    _tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:_tap];
}

-(void)magnifyImage:(UITapGestureRecognizer*) gesture
{
    NSLog(@"2222局部放大");
    UIButton *whichButton=(UIButton *)[gesture view];
    [SJAvatarBrowser showImage:whichButton.imageView];//调用方法
    
}
@end
