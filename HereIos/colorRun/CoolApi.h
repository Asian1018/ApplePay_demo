//
//  InitApi.h
//  colorRun
//
//  Created by engine on 15/11/2.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseApi.h"
//初始化api
@interface InitApi : BaseApi
@property(nonatomic,assign) NSInteger versionCode ;
@property(nonatomic,strong) NSString* versionName ;
@property(nonatomic,strong) NSString* deviceId ;
@property(nonatomic,strong) NSString* deviceToken ;
@property(nonatomic,strong) NSString* systemVersion ; // 手机系统版本
@property(nonatomic,strong) NSString* deviceModel ;// 设备型号
@property(nonatomic,assign) NSInteger clientType ;
@end
// 首页活动列表
@interface CoolActivityList : BaseApi  

@property(nonatomic,assign) NSInteger userId ;

@end
//活动详情
@interface CoolActivityDetail : BaseApi
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,assign) NSInteger oaId ;
@end

@interface LoginApi : BaseApi
@property(nonatomic,assign) NSInteger oauthType ; //1 : wb 2 : qq 3 : wx
@property(nonatomic,strong) NSString* oauthId ;
@property(nonatomic,strong) NSString* nickName ;
@property(nonatomic,strong) NSString* deviceToken ;
@property(nonatomic,assign) NSInteger clientType ;
@property(nonatomic,strong) NSString* avatar ;
@property(nonatomic,strong) NSString* position ;
@property(nonatomic,strong) NSString* birthday ;
@property(nonatomic,strong) NSString* sex ;
@property(nonatomic,strong) NSString* deviceId;

@end

//用户信息api
@interface GetUserInfo : BaseApi
@property(nonatomic,assign) NSInteger userId ;

@end

@interface Updatesignature : BaseApi
@property(nonatomic,assign) NSInteger userId ;

@property(nonatomic,strong) NSString* signature ;
@end
// 我的奖励
@interface Getrewardlist : BaseApi

@property(nonatomic,assign) NSInteger userId ;

@property(nonatomic,assign) NSInteger pageNo ;

@end
//我的运动
@interface Getrecordlist : BaseApi
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,assign) NSInteger pageNo ;
@end
//赛事卡券
@interface GetcardlistApi : BaseApi
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,assign) NSInteger pageNo ;
@end
//荣誉榜
@interface ActivityhonorApi : BaseApi
@property(nonatomic,assign) NSInteger oaId ;
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,assign) NSInteger pageNo ;
@property(nonatomic,assign) NSInteger pageSize;
@end

@interface GetLoginUrlApi : BaseApi
@property(nonatomic,assign) NSInteger userId ;
@end



@interface ShareImageApi : BaseApi
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,assign) NSInteger recordId ;
-(void) addFilePath:(NSString*)path ;
@end