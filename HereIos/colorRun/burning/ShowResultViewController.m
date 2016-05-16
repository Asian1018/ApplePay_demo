//
//  ShowResultViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/4.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "ShowResultViewController.h"

@interface ShowResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *prizeImage;

@end

@implementation ShowResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ShowResultViewController") ;
}
- (IBAction)dismissSelf:(id)sender {
    [self dismissViewControllerAnimated:self completion:^{
        NSLog(@"完成了");
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fillContabceForResultView:self.actvityDetail BurningModel:self.model] ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(NSString*)timeStringWithContance:(NSString*)contance{
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分ss秒"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSString * nowYear = [dateString substringToIndex:dateString.length - 11];
//    NSString * resultString = [NSString stringWithFormat:@"%@ %@",nowYear,contance];
//    return resultString;
//}
-(void)successMatch{
    
    NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
    NSString* dateTime = [NSString stringWithFormat:@"%@完成任务",self.date] ;
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:dateTime];
    [changeText addAttributes:fontDict range:NSMakeRange(dateTime.length-4,4)] ;
    self.dateLabel.text =  dateTime ;
    self.dateLabel.attributedText = changeText ;
    
}
-(void)fillContabceForResultView:(ActivityDetail*)detail BurningModel:(BurningModel *)model{
    if (!detail) {
        return;
    }
    /**
     detail.target
     *  0里程指标   1 时间指标
     */
//    detail.meter = 2;
    NSString * baseString = @"要再接再励~";
    NSString * moneyString = @"获得运动现金奖励";
    self.prizeImage.hidden = YES;
    self.continueLabel.hidden = YES;
//    BOOL success = NO;
    if (detail.isReward == 0) {
        //有奖励的活动
//        long dis = (long)[model.endDate timeIntervalSince1970] -  (long)[model.startDate timeIntervalSince1970];
//        switch (detail.claim) {
//            case 0:{
//                //里程要求
//                
//                self.timeLabel.text = [NSString stringWithFormat:@"%.2fkm",detail.meter *1.0/ 1000];
//                self.distanceLabel.text = [Utile TimeformatFromSeconds:dis];
//            }
//                break;
//            case 1:{
//                //时间要求
//                self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",model.totalMeter / 1000];
//                self.timeLabel.text = [Utile TimeformatFromSeconds:dis];
//                
//            }
//                break;
//            case 2:{
//                //里程和时间要求
//                self.distanceLabel.text = [NSString stringWithFormat:@"%@",[Utile TimeformatFromSeconds:dis]];
//                self.timeLabel.text = [NSString stringWithFormat:@"%.2fkm",model.totalMeter / 1000];
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
        //结果展示
        if (_status==0) {
            //成功
            [self successMatch];
            if (self.rewardType == 0) {
                //虚拟奖励
                self.prizeImage.hidden = NO;
                self.continueLabel.hidden = NO;
                self.continueLabel.text = moneyString;
            }
            else{
                //实物奖励
                self.prizeImage.hidden = NO;
                self.continueLabel.hidden = NO;
                self.continueLabel.text = @"获得实物奖一份~";
            
            }
        }
        else{
            self.dateLabel.text =[NSString stringWithFormat:@"%@未完成任务",self.date] ;
            if (self.rewardType == 0) {
                //虚拟奖励
                self.continueLabel.text = baseString;
                self.continueLabel.hidden = NO;
            }
            
        }
    }
    
}


@end
