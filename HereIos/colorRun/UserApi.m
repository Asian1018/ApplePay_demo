//
//  UserApi.m
//  colorRun
//
//  Created by engine on 16/1/26.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "UserApi.h"

@implementation ValidataPhoneApi
-(NSString*) getPath{
    return @"user/validate" ;
}
@end

@implementation RegistApi

-(NSString*) getPath{
    return @"user/register";
}

@end

@implementation PhoneLoginApi

-(NSString*) getPath{
    return @"user/login" ;
}

@end

@implementation ChangePassApi

-(NSString*) getPath{
    return @"user/updatepw" ;
}

@end
@implementation BindPhoneApi
-(NSString*) getPath{
    return @"user/bindaccount" ;
}
@end

@implementation UserbehaviorApi
-(NSString*) getPath{
    return @"user/userbehavior" ;
}
@end



@implementation UpdateUserApi{
    NSMutableArray* array ;
}
-(NSString*) getPath{
    return @"user/updateuser" ;
}
-(void) addFilePath:(NSString *)path{
    if (array==nil) {
        array=[NSMutableArray array] ;
    }
    [array addObject:path];
}
-(enum METHOD)getMethod{
    return POST;
}

-(NSArray*) getFileArray{
    return array ;
}
@end

@implementation UpdateNickNameApi
-(NSString*) getPath{
    return @"user/updatenickname" ;
}
@end



