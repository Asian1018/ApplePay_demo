//
//  PadingLabel.m
//  colorRun
//
//  Created by engine on 16/1/5.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "PadingLabel.h"

@implementation PadingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0, 8, 0, 8};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
