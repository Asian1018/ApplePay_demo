//
//  UILabel+AutoHeight.m
//  colorRun
//
//  Created by engine on 15/11/25.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "UILabel+AutoHeight.h"

@implementation UILabel (AutoHeight)
-(CGFloat) autoHeight{
    
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    CGSize labelsize = [self.text boundingRectWithSize:CGSizeMake(600, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|                       NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
//    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping] ;
    return labelsize.height ;
}
@end
