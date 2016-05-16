//
//  FMDBManager.h
//  colorRun
//
//  Created by engine on 15/11/19.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FMDBManager : NSObject
#define FMDB_FILENAME @"fmdb.sql"
@property(nonatomic,strong) FMDatabase* db ;
+(instancetype) sharedInstance ;
-(FMDatabase*) getDb ;
@end
