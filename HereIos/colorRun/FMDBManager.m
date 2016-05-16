//
//  FMDBManager.m
//  colorRun
//
//  Created by engine on 15/11/19.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "FMDBManager.h"
@implementation FMDBManager
//单例调用
static FMDBManager *instance;

+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(FMDatabase *)getDb{
    if (_db) {
        return _db ;
    }else{
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:FMDB_FILENAME];
        _db = [FMDatabase databaseWithPath:fileName];
        
        if (![_db open]) {
            NSLog(@"不行");
            return nil;
        }
        NSLog(@"行");
        return _db ;
    }
}
@end
