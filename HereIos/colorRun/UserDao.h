//
//  UserDao.h
//  colorRun
//
//  Created by engine on 15/11/9.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface UserDao : NSObject
-(NSInteger) insert:(User*) user ;
-(User*) loadUser;
-(void) deleteUser;
+(instancetype) sharedInstance ;
@end
