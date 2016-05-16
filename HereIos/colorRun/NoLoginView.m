//
//  NoLoginView.m
//  colorRun
//
//  Created by engine on 15/11/16.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "NoLoginView.h"

@implementation NoLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(UIView*) createNoLoginView:(CGRect) rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"nonelogin" owner:nil options:nil];
    NoLoginView *view = [nibView objectAtIndex:0] ;
    view.frame=rect ;
    return view ;
}
@end
