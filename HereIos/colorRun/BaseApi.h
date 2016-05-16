//
//  BaseApi.h
//  colorRun
//
//  Created by engine on 15/11/2.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseModel.h"
#import "AFNetworking.h"

@interface BaseApi : BaseModel

enum METHOD{
    GET,
    POST
};
-(NSString*) getPath ;
-(enum METHOD) getMethod ;
-(NSDictionary*) getParam ;
-(NSString*) getAddressHome ;
-(NSArray*) getFileArray ;

-(void) excuteWhithSuccess:(void (^)(NSURLSessionDataTask* response,id responseDate)) success failure:(void (^)(NSURLSessionDataTask* response,NSError* error)) failure ;
-(void) executeHasParse:(void (^)(id jsonData)) success failure:(void (^)(NSString* error)) failure;
//-(void) executeApiWhithModel:(void (^)(id model)) successModel failure:(void (^)(NSString* error)) failure ;
@end
