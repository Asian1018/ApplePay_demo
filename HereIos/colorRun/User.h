//
//  User.h
//  colorRun
//
//  Created by engine on 15/10/30.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel
#define USER_DEFAULT_USER_STORE_PATH @"Documents/userInfos"
@property(nonatomic,strong) NSString* nickName ;
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,strong) NSString* avatar;
@property(nonatomic,strong) NSString* createTime ;
@property(nonatomic,assign) NSInteger sex ;
@property(nonatomic,assign) NSInteger oauthType ;
@property(nonatomic,strong) NSString* oauthId ;
@property(nonatomic,strong) NSString* signature ;
@property(nonatomic,strong) NSString* position ;
@property(nonatomic,strong) NSString* kilometers ;
@property(nonatomic,strong) NSString* periods ;
@property(nonatomic,strong) NSString* remind ;//1、赛事卡券 2、运动奖励 3、我的圈子 4、消息通知
@property(nonatomic,assign) NSInteger follow ;
@property(nonatomic,assign) NSInteger fans ;
@property(nonatomic,strong) NSString* phone ;
@property(nonatomic,assign) NSInteger cardCount ;
@end
