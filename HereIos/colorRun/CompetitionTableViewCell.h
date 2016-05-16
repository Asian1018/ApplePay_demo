//
//  CompetitionTableViewCell.h
//  colorRun
//
//  Created by engine on 15/11/13.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface CompetitionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *status;
@property (weak, nonatomic) IBOutlet UIImageView *backgound;
-(void) fillUiWithModel:(MyCard*) card;
@end
