//
//  CALayer+XibConfiguration.m
//  colorRun
//
//  Created by zhidian on 16/1/13.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
