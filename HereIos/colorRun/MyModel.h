//
//  MyModel.h
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseModel.h"
//我的奖励
@interface MyRewardModel : BaseModel
@property(nonatomic,strong) NSString* rewardId ;
@property(nonatomic,strong) NSString* userId ;
@property(nonatomic,strong) NSString* title ;
@property(nonatomic,strong) NSString* subTitle ;
@property(nonatomic,strong) NSString* nickName ;
@property(nonatomic,strong) NSString* times ;
@property(nonatomic,strong) NSString* rank ;
@property(nonatomic,strong) NSString* all ;
@property(nonatomic,strong) NSString* period ;
@property(nonatomic,strong) NSString* pace ;
@property(nonatomic,strong) NSString* bewrite ;
@end
//我的运动
@interface MySport:BaseModel
@property(nonatomic)NSInteger recordId;
@property(nonatomic,assign) NSInteger sportType ;
@property(nonatomic,assign) NSInteger sportMode ;
@property(nonatomic,strong) NSString* kilometer ;
@property(nonatomic,strong) NSString* period ;
@property(nonatomic,strong) NSString* pace ;
@property(nonatomic,strong) NSString* oaId ;
@property(nonatomic,strong) NSString* runTime ;
@property(nonatomic,assign) CGFloat monthMeters ;
@end
//我的卡券
@interface MyCard : BaseModel
@property(nonatomic,assign) NSInteger cardId ;
@property(nonatomic,assign) NSInteger laId ;
@property(nonatomic,strong) NSString* title ;
@property(nonatomic,strong) NSString* startTime;
@property(nonatomic,strong) NSString* endTime ;
@property(nonatomic,strong) NSString* address ;
@property(nonatomic,assign) NSInteger status ;
@property(nonatomic,strong) NSString* background ;
@property(nonatomic,strong) NSString* qrCode; // 二维码图片地址

@end

@interface Activity : BaseModel

@property(nonatomic,assign) NSInteger activityId ;
@property(nonatomic,assign) NSInteger type ;
@property(nonatomic,strong) NSString* poster ;
@property(nonatomic,assign) NSInteger status ;
@property(nonatomic,strong) NSString * o2oUrl;

@end

@interface ActivityDetail : BaseModel
@property(nonatomic,assign) NSInteger meter ;//运动里程
@property(nonatomic,assign) NSInteger oaId ;
@property(nonatomic,assign) NSInteger status ;//1:挑战任务 2:挑战成功，可以继续挑战任务 3:挑战成功，不可以继续挑战任务 4:活动未开始 5:活动已结束
@property(nonatomic,assign) NSInteger type ;
@property(nonatomic,assign) NSInteger target ;
@property(nonatomic,assign) NSInteger count ;
@property(nonatomic,assign) NSInteger claim ;//任务要求 0里程要求 1时间要求 2 里程及时间要求
@property(nonatomic,assign) NSInteger period ;//运动时间
//@property(nonatomic,strong) NSString* kilometer ;
@property(nonatomic,strong) NSString* subPoster ;
@property(nonatomic,strong) NSString* startTime ;
@property(nonatomic,strong) NSString* endTime ;
@property(nonatomic,strong) NSString* activities ;
@property(nonatomic,strong) NSString* reward ;
@property(nonatomic,strong) NSString* rewardGrant ;
@property(nonatomic,strong) NSString* tips ;
@property(nonatomic,strong) NSString* officia ;
@property(nonatomic,strong) NSString* times  ;//
@property(nonatomic) NSInteger isReward; //是否设奖  0:是  1:否
@property(nonatomic,assign) NSInteger sportMode ;//0走路 1 跑步

@end


@interface ActivityUser : BaseModel
@property(nonatomic,assign) NSInteger type ;
@property(nonatomic,assign) NSInteger target ;
@property(nonatomic,assign) NSInteger userCount ;
@property(nonatomic,strong) NSString* avatar ;
@property(nonatomic,strong) NSString* nickName ;
@property(nonatomic,strong) NSString* period ;
@property(nonatomic,strong) NSString* kilometer ;
@property(nonatomic,strong) NSString* pace ;

@end
@interface HonorModel : BaseModel
@property(nonatomic,assign) NSInteger type ;
@property(nonatomic,assign) NSInteger target ;
@property(nonatomic,strong) NSString* nickName ;
@property(nonatomic,strong) NSString* avatar ;
@property(nonatomic,strong) NSString* period ;
@property(nonatomic,strong) NSString* kilometer ;
@property(nonatomic) NSInteger userId;
@end
@interface ActivityUserHonorModel : BaseModel
@property(nonatomic,assign) NSInteger oaId ;
@property(nonatomic,assign) NSInteger type ;
@property(nonatomic,assign) NSInteger target ;
@property(nonatomic,strong) NSString* sort ;
@property(nonatomic,strong) NSString* period ;
@property(nonatomic,strong) NSString* kilometer ;
@property(nonatomic)NSInteger status;
@end
