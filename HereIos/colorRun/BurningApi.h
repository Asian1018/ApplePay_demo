
#import "BaseApi.h"

//燃烧数据上传
@interface PostBurningApi : BaseApi
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,assign) NSInteger deviceType ;
@property(nonatomic,assign) NSInteger sportType ;//0: 普通运动类(燃烧生成数据) 1: 网络活动类(活动生成数据)
@property(nonatomic,assign) NSInteger sportMode ;//运动类型0走路1 跑步
@property(nonatomic,assign) NSInteger startTime ;
@property(nonatomic,assign) NSInteger endTime ;
@property(nonatomic,assign) NSInteger meter ; //运动总路程（米）
@property(nonatomic,copy) NSString * pace ; //时速 = 运动距离/时间
@property(nonatomic,copy) NSString * avgPace ; //平均配速 = 时间/运动距离，时间单位用min，路程单位用km
@property(nonatomic,copy) NSString * maxPace ; //最快配速 = 单位时间/单位时间内运动距离，max值
@property(nonatomic,copy) NSString * minPace ; //最慢配速 = 单位时间/单位时间内运动距离，min值

@property(nonatomic,assign) NSInteger status ; //是否最终批次数据0:是1:否
@property(nonatomic,copy) NSString* data ; // 轨迹JSON
@property(nonatomic,assign) NSInteger recordId ;//运动记录Id (可以为空)
@property(nonatomic,assign) NSInteger activityId ;//线上活动Id(可以为空)
@end

@interface JsobStringModel : BaseModel
@property(nonatomic) CGFloat latitude;
@property(nonatomic) CGFloat longitude;
@property(nonatomic) CGFloat distance;
@property(nonatomic) NSInteger time;//时间戳

@end
//其他人信息
@interface OtherPersonInfo : BaseApi
@property(nonatomic)NSInteger userId;
@property(nonatomic) NSInteger myUserId;
@end

//	其他人活动列表
@interface OtherSportList : BaseApi
@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger pageNo;
@property(nonatomic)NSInteger pageSize;

@end

//获取运动轨迹
@interface GetSportHistory : BaseApi
@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger recordId;
@end


//打开填写领奖信息接口

@interface OpenReward : BaseApi
@property(nonatomic)NSInteger rewardId;
@property(nonatomic)NSInteger userID;

@end

//保存领奖信息接口
@interface SaveReward : BaseApi
@property(nonatomic)NSInteger rewardId;
@property(nonatomic)NSInteger userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *address;

@end

//赛事卡劵详情
@interface GetCarDetail : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;

@end

//获取用户红包记录列表

@interface GetRedpacket : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;

@end

//我的战绩
@interface ActivityRecord : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@property(nonatomic) NSInteger oaId;

@end








