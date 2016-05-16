//
//  InitApi.m
//  colorRun
//
//  Created by engine on 15/11/2.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "CoolApi.h"

@implementation InitApi
-(NSString*) getPath{
    return @"config/initial" ;
}
@end

@implementation CoolActivityList

-(NSString*) getPath{
    return @"here/index" ;
}

@end

@implementation LoginApi

-(NSString*) getPath{
    return @"user/oauth" ;
}

@end
@implementation GetUserInfo

-(NSString *)getPath{
    return @"user/getuesr";
}

@end

@implementation Updatesignature

-(NSString *)getPath{
    return @"user/updatesignature";
}

@end

@implementation Getrewardlist

-(NSString *)getPath{
    return @"user/getrewardlist";
}

@end
@implementation Getrecordlist

-(NSString *)getPath{
    return @"user/getrecordlist" ;
}

@end

@implementation GetcardlistApi

-(NSString *)getPath{
    return @"user/getcardlist" ;
}

@end
@implementation CoolActivityDetail

-(NSString*) getPath{
    return @"here/activitydetail" ;
}

@end
@implementation ActivityhonorApi

-(NSString*) getPath{
    return @"here/activityhonor" ;
}
@end


@implementation GetLoginUrlApi
-(NSString*) getPath{
    return @"duiba/login" ;
}

@end


@implementation ShareImageApi{
    NSMutableArray* fileArray ;
}

-(enum METHOD) getMethod{
    return POST ;
}

-(NSString*) getPath{
    return @"here/sharedata" ;
}
-(void) addFilePath:(NSString *)path{
    if (fileArray == nil) {
        fileArray = [NSMutableArray array] ;
    }
    [fileArray addObject:path] ;
}
-(NSArray*) getFileArray{
    return fileArray ;
}



@end