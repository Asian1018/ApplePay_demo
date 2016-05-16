//
//  HereRunRecorderTrack.h
//  colorRun
//
//  Created by engine on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 满足一点数量的点之后一次清空所有的数据
 */
@interface HereRunRecorderTrack : NSObject
-(void) enqueque:(id) track ;
//拿出所有的点 并清空。保留上一次集合的最后一个点为本次的第一个点
-(NSArray*) allObject ;
-(NSArray*) pauseRecorder ;
-(void) cleanQueque ;
-(instancetype) initWhithLength:(NSInteger) length ;
@end
