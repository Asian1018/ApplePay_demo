
#import "BaseApi.h"
#import <CoreLocation/CoreLocation.h>
@interface BurningModel : BaseModel
@property(nonatomic)NSInteger sportMode; //运动类型 0走路 1跑步
@property(nonatomic,strong) NSString * locationString; // 轨迹JSON
@property(nonatomic,strong) NSDate * startDate;
@property(nonatomic, strong) NSDate * lastDate; //上一次记录的时间
@property(nonatomic) CGFloat totalMeter; // 总距离
@property(nonatomic) double startLat; //起点经度
@property(nonatomic) double startLong; // 纬度
@property(nonatomic, strong) NSDate * endDate; //结束记录的时间
@property(nonatomic,copy) NSString * pace ; //时速 = 运动距离/时间
@property(nonatomic,copy) NSString * avgPace ; //平均配速 = 时间/运动距离，时间单位用min，路程单位用km
@property(nonatomic,copy) NSString * maxPace ; //最快配速 = 单位时间/单位时间内运动距离，max值
@property(nonatomic,copy) NSString * minPace ; //最慢配速 = 单位时间/单位时间内运动距离，min值

/**
 *   CLLocationCoordinate2D startCoordinate; //起点经纬度
 CLLocationCoordinate2D lastCoordinate; // 上一次记录的经纬度
 NSDate * lastDate; //上一次记录的时间
 CGFloat totalMeter; // 总距离
 NSDate * startDate;

 */
@end

@interface OtherPersonModel: BaseModel
@property(nonatomic)NSInteger oauthType; //第三方平台类型:0:weibo 1:qq 2:wx
@property(nonatomic,copy) NSString * oauthId ; //第三方平台ID
@property(nonatomic,copy) NSString * avatar ; //用户头像
@property(nonatomic,copy) NSString * createTime ; //加入时间
@property(nonatomic,copy) NSString * signature ; //个性签名
@property(nonatomic) NSInteger sex ; //性别 0：未知1：男2：女
@property(nonatomic,copy) NSString * nickName ; //昵称
@property(nonatomic,copy) NSString * position ; //位置
@property(nonatomic,copy) NSString * kilometers ; //累计里程
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * periods;//累计时长
@property(nonatomic) NSInteger follow;//关注数
@property(nonatomic) NSInteger fans;//关注者
@property(nonatomic) NSInteger relation;// 0 未关注1 已关注
@property(nonatomic) NSInteger cardCount;//卡片数目



@end

@interface OtherPersonListModel : BaseModel
@property(nonatomic)NSInteger userId; //用户id
@property(nonatomic) NSInteger activityId; //活动id
@property(nonatomic) NSInteger type; //类型(1: o2o活动，2: 线上活动)
@property(nonatomic,copy) NSString * title ; //活动名称
@property(nonatomic,copy) NSString * startTime ; //活动开始时间
@property(nonatomic,copy) NSString * endTime ; //活动结束时间
@property(nonatomic,copy) NSString * joinTime ; //加入时间
@property(nonatomic,strong) NSString * o2oUrl; //o2o赛事
@end

@interface SportHistory : BaseModel
@property(nonatomic) NSInteger meter; //运动总路程（米）
@property(nonatomic,copy) NSString * pace ; //时速 = 运动距离/时间
@property(nonatomic,copy) NSString * avgPace ; //平均配速 = 时间/运动距离，时间单位用min，路程单位用km
@property(nonatomic,copy) NSString * maxPace ; //最快配速 = 单位时间/单位时间内运动距离，max值
@property(nonatomic,copy) NSString * minPace ; //最慢配速 = 单位时间/单位时间内运动距离，min值
@property(nonatomic) NSInteger startTime ; //活动开始时间
@property(nonatomic) NSInteger endTime ; //活动结束时间
@property(nonatomic,copy) NSString*  data ; //轨迹json
@property(nonatomic,copy) NSString * shareUrl;//分享地址
@end
//我的红包记录
@interface MyTredPacket : BaseModel
@property(nonatomic) NSInteger userId;
@property(nonatomic,copy) NSString * date ;
@property(nonatomic,copy) NSString * bewrite ; //描述
@property(nonatomic,copy) NSString * amount ; //最操作金额

@end
//我的战绩
@interface MyRecond : BaseModel
@property(nonatomic) NSInteger recordId; //运动记录Id
@property(nonatomic) NSInteger sportMode; //运动模式   0: 走路   1: 跑步
@property(nonatomic) NSInteger oaId; //线上活动id
@property(nonatomic,copy) NSString * kilometer ; //描述
@property(nonatomic,copy) NSString * period ; //运动时长
@property(nonatomic,copy) NSString * pace ; //描述
@property(nonatomic) NSInteger runTime; //跑步时间cuo
@property(nonatomic) NSInteger count; //挑战次数



/*
recordId	Integer	运动记录Id
sportMode	Integer	运动模式
0: 走路
1: 跑步
oaId	Integer	线上活动id
kilometer	String	运动里程(公里)
period	String	运动时长
pace	String	配速
runTime	Long	跑步时间
count  	Integer	挑战次数
*/


@end


