//
//  UILabel+ColorChange.m
//  colorRun
//
//  Created by zhidian on 16/5/16.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "UILabel+ColorChange.h"

@implementation UILabel(ColorChange)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)colorChangeAction{
    self.textColor = [UIColor redColor];
    self.font = [UIFont systemFontOfSize:18];

}
@end
