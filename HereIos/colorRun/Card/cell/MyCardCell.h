//
//  MyCardCell.h
//  colorRun
//
//  Created by zhidian on 16/1/12.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCardCell;
@protocol MyCardCellDelegate <NSObject>
-(void)signCardAction:(MyCardCell*)cell;

@end

@interface MyCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageview;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *signCardButton;
@property (weak, nonatomic) id<MyCardCellDelegate>delegate;

-(void)fillCellWithModel:(MyCardListModel*)model;
@end
