//
//  HereRunRecorderTrack.m
//  colorRun
//
//  Created by engine on 16/1/19.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "HereRunRecorderTrack.h"
@interface HereRunRecorderTrack(){
    NSMutableArray* array ;
    NSInteger totalLength  ;
}
@end
@implementation HereRunRecorderTrack
-(instancetype) initWhithLength:(NSInteger)length{
    array=[NSMutableArray array] ;
    totalLength=length ;
    return self ;
}
-(void) enqueque:(id)track{
    [array addObject:track];
}

-(NSArray* ) allObject{
   
    if (totalLength==array.count) {
        return array ;
    }
    return nil ;
}
-(NSArray*) pauseRecorder{
    return array ;
}
-(void) cleanQueque{
    [array removeAllObjects] ;
}


@end
