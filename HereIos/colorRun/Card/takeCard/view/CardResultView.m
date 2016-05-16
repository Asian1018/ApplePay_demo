//
//  CardResultView.m
//  colorRun
//
//  Created by zhidian on 16/1/26.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "CardResultView.h"

@implementation CardResultView

-(id)initWithCountString:(NSString*)string{
    if (self = [super init]) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"cardResult" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.desLabel.text = string;
    }
    return self;
}

- (IBAction)cancleButtonClicked:(id)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(dismissViewAction)]) {
        [self.delegate dismissViewAction];
    }
}

@end
