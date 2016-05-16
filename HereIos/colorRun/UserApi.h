//
//  UserApi.h
//  colorRun
//
//  Created by engine on 16/1/26.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "BaseApi.h"

@interface ValidataPhoneApi : BaseApi
@property(strong,nonatomic) NSString* phone ;
@property(strong,nonatomic) NSString* securityCode ;
@property(assign,nonatomic) NSInteger clientType ;
@property(assign,nonatomic) NSInteger type  ;
@end

@interface RegistApi : BaseApi
@property(strong,nonatomic) NSString* account ;
@property(strong,nonatomic) NSString* password ;
@property(strong,nonatomic) NSString* deviceToken ;
@property(assign,nonatomic) NSInteger clientType ;
@property(strong,nonatomic) NSString* deviceId ;
@property(strong,nonatomic) NSString* position ;
@end

@interface PhoneLoginApi : BaseApi
@property(strong,nonatomic) NSString* account ;
@property(strong,nonatomic) NSString* password ;

@end
@interface ChangePassApi : BaseApi
@property(strong,nonatomic) NSString* account ;
@property(strong,nonatomic) NSString* password ;
@end

@interface BindPhoneApi : BaseApi
@property(assign,nonatomic) NSInteger userId ;
@property(strong,nonatomic) NSString* account ;
@property(strong,nonatomic) NSString* password ;
@end

@interface UserbehaviorApi : BaseApi
@property(strong,nonatomic) NSString* deviceId ;
@property(assign,nonatomic) NSInteger type ;
@property(assign,nonatomic) NSInteger behavior ;
@end

@interface UpdateUserApi : BaseApi
@property(assign,nonatomic) NSInteger userId ;
@property(assign,nonatomic) NSInteger sex ;
-(void) addFilePath:(NSString*) path ;
@end
@interface UpdateNickNameApi : BaseApi
@property(assign,nonatomic) NSInteger userId ;
@property(strong,nonatomic) NSString* nickname ;
@end

