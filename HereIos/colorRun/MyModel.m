//
//  MyModel.m
//  colorRun
//
//  Created by engine on 15/11/12.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "MyModel.h"

@implementation MyRewardModel
+(instancetype) emptyInstance{
    return [[MyRewardModel alloc] init] ;
}
@end

@implementation MySport
+(instancetype) emptyInstance{
    return [[MySport alloc]init] ;
}
@end

@implementation MyCard
+(instancetype) emptyInstance{
    return [[MyCard alloc]init] ;
}

@end

@implementation Activity

+(instancetype) emptyInstance{

    return [[Activity alloc]init] ;
}

@end
@implementation ActivityDetail
+(instancetype) emptyInstance{
    return [[ActivityDetail alloc]init] ;
}
@end
@implementation ActivityUser
+(instancetype) emptyInstance{
    return [[ActivityUser alloc] init] ;
}
@end
@implementation HonorModel
+(instancetype) emptyInstance{
    return [[HonorModel alloc] init];
}
@end
@implementation ActivityUserHonorModel
+(instancetype) emptyInstance{
    return [[ActivityUserHonorModel alloc]init] ;
}

@end