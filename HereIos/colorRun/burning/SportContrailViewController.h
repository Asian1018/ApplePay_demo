
#import <UIKit/UIKit.h>
#import "BurningModel.h"
@interface SportContrailViewController : UIViewController
@property(nonatomic, copy)NSArray * locatArray; // 坐标点数组
@property (weak, nonatomic) IBOutlet UILabel *speedPerHourLabel;//时速
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;//平均速度
@property (weak, nonatomic) IBOutlet UILabel *fastestSpeedLabel;//最快配速
@property (weak, nonatomic) IBOutlet UILabel *slowestSpeedLabel;//最慢配速
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic) NSInteger recordId;//活动ID
@property (nonatomic ,strong) BurningModel * burnModel;
@property (nonatomic, strong)NSString * fromType; //0地图过来  1 运动历史过来
@property(nonatomic,strong) ActivityDetail* activityDetail ;
@property(nonatomic,strong) NSString * shareUrl;//分享地址

@property(strong,nonatomic) NSString *rewardBewrite; //奖励描述
@property(nonatomic) NSInteger rewardType; //0:虚拟类型 1:实物类型
@property(nonatomic,strong) NSString* date  ; //时间
@property(nonatomic,assign) NSInteger status ;//是否完成任务
@property(nonatomic) NSInteger cardMeter;//卡片目标里程//米
@property(nonatomic,strong)CardInfoModel * models;
@end
