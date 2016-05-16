
#import <UIKit/UIKit.h>
#import "BurningModel.h"
#import "HereRunRecorderTrack.h"
@interface RunMapsViewController : UIViewController
enum RunStatus{
    RUN,
    PAUSE
};
@property (nonatomic ,strong) BurningModel * burnModel;
@property(nonatomic)NSInteger sportMode; //运动类型 0走路 1跑步
@property(nonatomic)NSInteger sportType;//0: 普通运动类(燃烧生成数据) 1: 网络活动类(活动生成数据) 2.卡片活动(待确定)
@property(nonatomic)NSInteger recordId;// 运动记录Id
@property(nonatomic)NSInteger activityId;//线上活动Id
//@property(nonatomic ,strong)NSString * locationString;//经纬度字符串
@property(nonatomic ,strong)NSMutableArray * locationArray;//记录经纬度的数组
@property(nonatomic,strong) ActivityDetail* activityDetail ;
@property(nonatomic) NSInteger cardMeter;//卡片目标里程//米
@property(nonatomic,strong)CardInfoModel * models;
@end
