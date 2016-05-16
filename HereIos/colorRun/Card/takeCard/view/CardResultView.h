//
//  CardResultView.h
//  colorRun
//
//  Created by zhidian on 16/1/26.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardResultView;
@protocol CardResultViewDelegate <NSObject>

-(void)dismissViewAction;

@end
@interface CardResultView : UIView
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
-(id)initWithCountString:(NSString*)string;
@property(weak,nonatomic) id<CardResultViewDelegate>delegate;
@end
