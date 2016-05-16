
#import "CardApi.h"

@implementation GetUserCard
-(NSString*) getPath{
    return @"card/getusercard" ;
}

@end

@implementation CreateCard
-(NSString*) getPath{
    return @"card/createcard" ;
}

@end

@implementation GetCardApi
-(NSString*) getPath{
    return @"card/getcard" ;
}

@end

@implementation GetCardDetail
-(NSString*) getPath{
    return @"card/getcarddetail" ;
}

@end

@implementation CardRankingApi
-(NSString*) getPath{
    return @"card/cardranking" ;
}

@end

@implementation FindCard
-(NSString*) getPath{
    return @"card/findcard" ;
}

@end

@implementation FindCardList
-(NSString*) getPath{
    return @"card/findcardlist" ;
}

@end

@implementation FindCardUser
-(NSString*) getPath{
    return @"card/findcarduser" ;
}


@end

@implementation CardHandle
-(NSString*) getPath{
    return @"card/handle" ;
}


@end

@implementation LikeApi
-(NSString*) getPath{
    return @"card/like" ;
}


@end

@implementation CardInvite
-(NSString*) getPath{
    return @"card/invite" ;
}


@end

@implementation CardShareData{
    NSMutableArray* fileArray ;
}


-(NSString*) getPath{
    return @"card/clock" ;
}

-(enum METHOD) getMethod{
    return POST ;
}
-(void) addFilePath:(NSString *)path{
    if (fileArray == nil) {
        fileArray = [NSMutableArray array] ;
    }
    [fileArray addObject:path] ;
}
-(NSArray*) getFileArray{
    return fileArray ;
}



@end

@implementation MyCardListApi

-(NSString*) getPath{
    return @"user/cardlist" ;
}

@end

@implementation GroupListApi
-(NSString*) getPath{
    return @"user/grouplist" ;
}

@end

@implementation InteractListApi

-(NSString*) getPath{
    return @"user/interactlist" ;
}

@end

@implementation InteractrelationApi

-(NSString*) getPath{
    return @"user/interactrelation" ;
}

@end

@implementation FollowApi

-(NSString*) getPath{
    return @"user/follow" ;
}

@end
@implementation CancleFollow

-(NSString*) getPath{
    return @"user/cancelfollow" ;
}

@end

@implementation Handleremind

-(NSString*) getPath{
    return @"card/handleremind" ;
}

@end


@implementation QuickCard
-(NSString*) getPath{
    return @"card/handlequit";
}


@end

@implementation AddCard
-(NSString*) getPath{
    return @"card/handleadd";
}

@end

@implementation DeleteCard

-(NSString*) getPath{
    return @"card/handledel";
}

@end
@implementation NotNotifi

-(NSString*) getPath{
    return @"user/fans";
}

@end

@implementation Sensitive

-(NSString*) getPath{
    return @"config/sensitive";
}

@end

