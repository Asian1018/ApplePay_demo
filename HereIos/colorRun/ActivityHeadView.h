//
//  ActivityHeadView.h
//  colorRun
//
//  Created by engine on 15/11/24.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface ActivityHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
@property (weak, nonatomic) IBOutlet UILabel *pepleCount;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *bestTime;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *times;
+(instancetype)creatActivityHead ;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
-(void) fillUiWhitActivityDetail:(ActivityDetail*) detail withActivityUser:(ActivityUser*) user ;
@end
