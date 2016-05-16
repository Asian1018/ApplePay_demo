//
//  MySportTableViewCell.m
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "MySportTableViewCell.h"
@implementation MySportTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.time.textColor = [Utile orange];
    
}
-(void)setFrame:(CGRect)frame{
    if (frame.size.width < 322) {
        UIFont * fo = [UIFont systemFontOfSize:15];
        self.pace.font = fo;
        self.period.font = fo;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) fillUiWithMode:(MySport *)sport{
    _kilometer.text=[NSString stringWithFormat:@"%@ 公里",sport.kilometer] ;
    _pace.text = [NSString stringWithFormat:@"%@/km",sport.pace] ;
    _period.text=sport.period ;
    if (sport.sportMode==0) {//走路
        UIImage* image=[UIImage imageNamed:@"my_walk"] ;
        _runType.image=image ;
    }else{
        UIImage* image=[UIImage imageNamed:@"my_run"] ;
        _runType.image = image ;
    }
    if (sport.sportType==0) {
        _activityType.hidden=YES ;
    }else{
        _activityType.hidden=NO ;
    }
    NSInteger day = [Utile getDay:[sport.runTime longLongValue]] ;
    NSString* timeDesc = [Utile getTimeDesc:[sport.runTime longLongValue]] ;
    _time.text=[NSString stringWithFormat:@"%lu日%@",day,timeDesc] ;
}
@end
