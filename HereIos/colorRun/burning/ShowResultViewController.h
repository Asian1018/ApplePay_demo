//运动结果页

#import <UIKit/UIKit.h>
#import "MyModel.h"
#import "BurningModel.h"
@interface ShowResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *continueLabel;//再接再厉
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) ActivityDetail* actvityDetail ;
@property (strong,nonatomic) BurningModel* model ;
@property(strong,nonatomic) NSString *rewardBewrite;
@property(nonatomic) NSInteger rewardType; //0:虚拟类型 1:实物类型
@property(strong,nonatomic) NSString* date ;
@property(assign,nonatomic) NSInteger status ;//是否完成任务 0成功 1失败
-(void)fillContabceForResultView:(ActivityDetail*)detail BurningModel:(BurningModel*)model;



@end
