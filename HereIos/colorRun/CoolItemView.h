//
//  CoolItemView.h
//  colorRun
//
//  Created by engine on 15/10/22.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@protocol ItemClick <NSObject>

-(void) onActivityClick:(Activity*) model;

@end

@interface CoolItemView : UIView
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (nonatomic,strong) Activity* activity ;
@property (nonatomic,strong) id<ItemClick> delegate ;
+ (CoolItemView*) initCoolItemView:(CGRect) rect;
+ (CoolItemView*) initCoolItemView:(CGRect) rect whithModel:(Activity*) model;
@end

