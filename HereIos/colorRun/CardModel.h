
#import "BaseModel.h"


//我的卡片
@interface MyCardListModel : BaseModel
@property(nonatomic) NSInteger qcId; //卡片资格ID
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource; //0:个人卡片1:官方卡片
@property(nonatomic) NSInteger broadcast; //是否广播 0 是1 否
@property(nonatomic) NSInteger target; //卡片目标   0:无1:计步2:跑步
@property(nonatomic) NSInteger targetValue; //目标值 Target:计步数  Target:跑步里程（米）为单位
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger days;
@property(nonatomic) NSInteger cardCount;//卡片参加人数
@property(nonatomic) NSInteger createCard;//是否创建者 0 是1 否
@property(nonatomic,strong) NSString * createTime;
@property(nonatomic) NSInteger cardStatus;///0 正常  1 下架/过期
@property(nonatomic) NSInteger clockStatus; //0 未加入卡片  1已打卡  2未打卡
@end

//创建卡片
@interface CreadCardModel : BaseModel
@property(nonatomic) NSInteger cardId;
@property(nonatomic,copy) NSString* image;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * shareUrl;

@end

//卡片信息
@interface CardInfoModel : BaseModel
@property(nonatomic) NSInteger qcId; //卡片资格ID
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource;//卡片来源 0:个人卡片1:官方卡片
@property(nonatomic) NSInteger target; //卡片目标  0:无1:计步2:跑步
@property(nonatomic) NSInteger targetValue; //目标值 Target:计步数  Target:跑步里程（米）为单位
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger days;
@property(nonatomic) NSInteger cardStatus;//卡片状态 0正常 1下架/过期
@property(nonatomic) NSInteger clockStatus;//打卡状态0 未加入卡片 1已打卡 2未打卡
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSString * position;//位置
@property(nonatomic) NSInteger isReward;//是否有奖品 0 是 1否
@property(nonatomic,strong) NSString * prizeName;
@property(nonatomic,strong) NSString * prizeDetail;
@property(nonatomic,strong) NSString * prizePoster; //奖品缩略图url
@property(nonatomic,strong) NSString * prizeSubPoster;//奖品高清图url
@property(nonatomic) NSInteger userDays;//坚持打卡天数
@end

@interface CardRecordList : BaseModel
@property(nonatomic) NSInteger recordId;
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger likes;//赞
@property(nonatomic) NSInteger isLike;//是否赞过  0 是1 否
@property(nonatomic,strong) NSString * position;//位置
@property(nonatomic) NSInteger isPosition;//是否显示位置 0 是1 否
@property(nonatomic) NSInteger createTime;
@property(nonatomic,strong) NSString * o2oUrl;
@property(nonatomic,strong) NSString* clockImg;//图片Json数组集合

@end

//卡片详情
@interface CardDetailModel : BaseModel
@property(nonatomic) NSInteger qcId; //卡片资格ID
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource;//卡片来源 0:个人卡片1:官方卡片
@property(nonatomic) NSInteger target; //卡片目标  0:无1:计步2:跑步
@property(nonatomic) NSInteger targetValue; //目标值 Target:计步数  Target:跑步里程（米）为单位
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * bewrite;//卡片说明
@property(nonatomic) NSInteger isReward;//是否有奖品 0 是 1否
@property(nonatomic,strong) NSString * prizeName;
@property(nonatomic,strong) NSString * prizeDetail;
@property(nonatomic) NSInteger createCard;//是否创建者 0 是1 否
@property(nonatomic) NSInteger joinCount;//参与人数
@property(nonatomic) NSInteger userCount;//邀请人数
@property(nonatomic) NSInteger broadcast;//是否广播 0 是1 否
@property(nonatomic) NSInteger isRemind;
@property(nonatomic) NSInteger remindTime; //提醒时间 60*60 点数
@property(nonatomic,strong) NSString * shareUrl;//分享地址
@end


@interface UserCardModel : BaseModel
//@property(nonatomic) NSInteger cardId;
@property(nonatomic,strong) NSString * sort;//排名(100/1000)
@property(nonatomic) NSInteger days;
@property(nonatomic) NSInteger status;//打卡状态 0 未获取打卡资格 1 打卡未开始 2 打卡已结束 3 已打卡 4未打卡

@end

@interface CardRankingList : BaseModel
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic) NSInteger days;
@end

@interface FocusCardList : BaseModel
@property(nonatomic) NSInteger cardType;
@property(nonatomic) NSInteger cardId;
@property(nonatomic,strong) NSString * focusImg;//焦点位海报
@end

@interface RecommCardList : BaseModel
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource;//卡片来源 0:个人卡片1:官方卡片
@property(nonatomic) NSInteger isPrize;//是否有奖品 0 是 1否
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger cardCount;//卡片参加人数
@end

@interface HotCardList : BaseModel
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource;//卡片来源 0:个人卡片1:官方卡片
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger cardSum;//卡片打卡次数
@property(nonatomic) NSInteger cardCount;//卡片参加人数

@end


@interface MoreCardList : BaseModel
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger cardSource;//卡片来源 0:个人卡片1:官方卡片
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger cardSum;//卡片打卡次数
@property(nonatomic) NSInteger cardCount;//卡片参加人数
@property(nonatomic) NSInteger findType;//卡片列表类型 0 推荐卡片 1 热度卡片
@property(nonatomic) NSInteger isPrize;//是否有奖品 0 是 1否
@end
//用户圈子列表
@interface GroupList : BaseModel
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic) BOOL isShow;
@end

//用户互动消息列表
@interface InteractList : BaseModel
@property(nonatomic,strong) NSString * msgTitle;
@property(nonatomic) NSInteger mId;
@property(nonatomic,strong) NSString * msgDewrite;//消息内容
@property(nonatomic) NSInteger createTime;
@property(nonatomic,strong) NSString * msgAvatar;
@property(nonatomic) NSInteger type;//1: 赞 2: 加入卡片 3: 邀请卡片 4: 分享
@property(nonatomic) NSInteger commonId;//卡片ID\运动记录Id
@property(nonatomic,strong) NSString * shareUrl;
@property(nonatomic) NSInteger commonType;//0:快捷1:图片2:计步3:跑步
@end


@interface InteractRelation : BaseModel
@property(nonatomic) NSInteger type;//互动消息分类 1: 赞 2: 加入卡片
@property(nonatomic) NSInteger userId;
@property(nonatomic,strong) NSString * nickName;
@property(nonatomic,strong) NSString * avatar;
@property(nonatomic) NSInteger relation;//关系 0 未关注1 已关注
@end




















