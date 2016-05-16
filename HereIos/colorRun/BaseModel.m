//
//  BaseModel.m
//  colorRun
//
//  Created by engine on 15/10/29.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel
-(NSArray*) PropertyKeys{
    unsigned int outCount,i ;
    objc_property_t *pp = class_copyPropertyList([self class],&outCount);
    NSMutableArray *keys = [[NSMutableArray alloc]initWithCapacity:0];
    for (i=0; i<outCount; i++) {
        objc_property_t property=pp[i] ;
        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding] ;
        [keys addObject:propertyName] ;
    }
    free(pp);
    return  keys ;
}

+(instancetype) initWithJSON:(id)json{
    id model = [self emptyInstance];
    for (NSString* key  in [model PropertyKeys]) {
        id value = [json objectForKey:key] ;
        if (value!=nil&&![value isEqual:[NSNull null]]) {
            [model setValue:[json objectForKey:key] forKey:key] ;
        }
    }
    return model ;
}

+(instancetype) emptyInstance{
    return [[BaseModel alloc]init] ;
}

@end
