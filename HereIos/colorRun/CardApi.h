
#import "BaseApi.h"
//我的卡片
@interface GetUserCard : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@end

//创建卡片
@interface CreateCard : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger broadcast;//是否广播 0 是1 否
@property(nonatomic) NSInteger cardMode; //0:运动要目标1:生活也要玩
@property(nonatomic) NSInteger cardType; //0:快捷1:图片2:计步3:跑步
@property(nonatomic) NSInteger target; //卡片目标  0:无1:计步2:跑步
@property(nonatomic) NSInteger targetValue; //目标值 Target:计步数  Target:跑步里程（米）为单位
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * bewrite;//卡片说明
//@property(nonatomic) NSInteger isRemind;//是否打开提醒 0 是1 否
//@property(nonatomic) NSInteger remind;//提醒时间
@end

//卡片信息接口
@interface GetCardApi : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;

@end

//卡片详情接口
@interface GetCardDetail : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;

@end

//卡片榜单接口
@interface CardRankingApi : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;

@end

//发现卡片接口
@interface FindCard : BaseApi

@end

//发现卡片列表接口(更多)
@interface FindCardList : BaseApi
@property(nonatomic) NSInteger findType;//0 推荐卡片 1 热度卡片
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@end

//发现卡片用户列表接口
@interface FindCardUser : BaseApi
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@end

//用户操作卡片（加入，退出，删除）调用接口
@interface CardHandle : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger card;
@property(nonatomic) NSInteger type;//操作类型 0 加入1 退出2 删除

@end

//赞打卡
@interface LikeApi : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger recordId;//打卡记录ID

@end

//邀请卡片列表
@interface CardInvite : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;
@property(nonatomic,strong) NSString * users;//用户组
@end

//打卡接口
@interface CardShareData : BaseApi
@property(nonatomic) NSInteger qcId;//卡片资格Id
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;
@property(nonatomic,strong) NSString * title;
@property(nonatomic) NSInteger target;//卡片目标  0:无1:计步2:跑步
@property(nonatomic) NSInteger targetValue; //目标值 Target:计步数  Target:跑步里程（米）为单位
@property(nonatomic,strong) NSString * position;
@property(nonatomic) NSInteger isPosition;//是否显示位置 0 是1 否
@property(nonatomic,strong) NSString * file0;//打卡图片文件1
@property(nonatomic,strong) NSString * file1;//打卡图片文件2
@property(nonatomic,strong) NSString * file2;//打卡图片文件3
@property(nonatomic,strong) NSString * file3;//打卡图片文件4
-(void) addFilePath:(NSString*)path ;
@end

//用户卡片列表
@interface MyCardListApi : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@end

//用户圈子列表
@interface GroupListApi : BaseApi
@property(nonatomic) NSInteger userId;

@end

//用户互动消息列表
@interface InteractListApi : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;

@end

//互动关系列表
@interface InteractrelationApi : BaseApi
@property(nonatomic) NSInteger mId;
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger pageNo;
@property(nonatomic) NSInteger pageSize;
@end

//关注
@interface FollowApi : BaseApi
@property(nonatomic) NSInteger userId;//关注者用户ID
@property(nonatomic) NSInteger followUserId;//被关注者用户ID
@end
//取消关注
@interface CancleFollow : BaseApi
@property(nonatomic) NSInteger userId;//关注者用户ID
@property(nonatomic) NSInteger followUserId;//被关注者用户ID
@end


//修改时间提醒
@interface Handleremind : BaseApi
@property(nonatomic) NSInteger isRemind;//是否打开提醒 0 是1 否
@property(nonatomic) NSInteger remindTime;
@property(nonatomic) NSInteger qcId;//卡片资格Id
@end

@interface QuickCard : BaseApi
@property(nonatomic) NSInteger qcId;
@end

@interface AddCard : BaseApi
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger cardId;

@end

//删除卡片
@interface DeleteCard : BaseApi
@property(nonatomic,strong) NSString * qcIds;//卡片资格ID Json [1,2,3,4]

@end

//未关注的用户
@interface NotNotifi : BaseApi
@property(nonatomic) NSInteger userId;
@end

//检验敏感词
@interface Sensitive : BaseApi
@property(nonatomic,strong) NSString * content;
@end





