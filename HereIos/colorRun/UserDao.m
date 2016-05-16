//
//  UserDao.m
//  colorRun
//
//  Created by engine on 15/11/9.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "UserDao.h"
#import "FMDBManager.h"
@implementation UserDao
//单例调用
static UserDao *instance;
-(NSInteger)insert:(User *)user{
    [self saveUser:user] ;
    return 0 ;
}
-(User*)loadUser{
    return [self getUser];
}

-(void)deleteUser{
//    NSString* sql = @"DELETE FROM User";
//    FMDatabase *db = [[FMDBManager sharedInstance]getDb] ;
//    [db executeUpdate:sql] ;
    
    User* user = [[User alloc]init] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* userKey = [user PropertyKeys] ;
    for (NSString* key in userKey) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize] ;
}

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void) saveUser:(User*)user{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* userKey = [user PropertyKeys] ;
    for (NSString* key in userKey) {
        if ([user valueForKey:key] !=nil ) {
            [userDefaults setObject:[user valueForKey:key] forKey:key];
        }
    }
    [userDefaults synchronize] ;
}

-(User*) getUser{
    User* user = [[User alloc]init] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* userKey = [user PropertyKeys] ;
    for (NSString* key in userKey) {
        id value = [userDefaults objectForKey:key] ;
        if (value!=nil) {
             [user setValue:value forKey:key] ;
        }
       
    }
    if (user.userId>0) {
        return user ;
    }
    return nil ;
}
@end
