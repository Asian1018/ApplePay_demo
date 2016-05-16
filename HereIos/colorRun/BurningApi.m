//
//  BurningApi.m
//  colorRun
//
//  Created by zhidian on 15/11/27.
//  Copyright © 2015年 engine. All rights reserved.
//

#import "BurningApi.h"

@implementation PostBurningApi

-(NSString*) getPath{
    return @"here/sportsdata" ;
}

-(enum METHOD)getMethod{
    return POST;
}

@end

@implementation JsobStringModel

@end

@implementation OtherPersonInfo
-(NSString*) getPath{
    return @"user/otheruser" ;
}

@end

@implementation OtherSportList

-(NSString*) getPath{
    return @"user/otheruseractivity";

}

@end
@implementation GetSportHistory
-(NSString*) getPath{
    return @"here/getlocus";
    
}

@end

@implementation OpenReward

-(NSString*) getPath{
    return @"user/openreward";
    
}
-(enum METHOD)getMethod{
    return POST;
    
}

@end

@implementation SaveReward

-(NSString*) getPath{
    return @"user/savereward";
    
}
-(enum METHOD)getMethod{
    return POST;
    
}

@end

@implementation GetCarDetail

-(NSString*) getPath{
    return @"user/getcarddetail";
    
}
@end

@implementation GetRedpacket

-(NSString*) getPath{
    return @"user/getredpacket";
    
}
@end

@implementation ActivityRecord

-(NSString*)getPath{
    
    return @"here/activityrecord";
}

@end
