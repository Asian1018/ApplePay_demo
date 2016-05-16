//
//  HonorTableViewCell.h
//  colorRun
//
//  Created by engine on 15/11/25.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface HonorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *honorIcon;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

-(void) fillUiWithModel:(HonorModel*) model  ;
-(void) withIcon:(NSString*) image index:(NSInteger) index type:(NSInteger)type ;
@end
