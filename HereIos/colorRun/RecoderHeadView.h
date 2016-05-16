//
//  RecoderHeadView.h
//  colorRun
//
//  Created by engine on 15/11/11.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecoderHeadView;
@protocol RecoderHeadViewDelegate <NSObject>
/**
 *  查看红包记录
 */
-(void)showMyMoneyListAction;
/**
 *  体现
 */
-(void)getMoneyAction;
@end

@interface RecoderHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *redPackage;
@property (weak, nonatomic) id<RecoderHeadViewDelegate>delegate;
+(instancetype) createHeadView ;
-(void) setRedPackageText:(NSString*) redPackage;
@end
