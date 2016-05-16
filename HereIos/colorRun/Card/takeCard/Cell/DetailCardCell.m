
#import "DetailCardCell.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "SJAvatarBrowser.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
@implementation DetailCardCell{
    NSInteger cardIds;
    CardRecordList *cardModels;
    UIImageView * buttonView;
}

#define PIC_COUNT 4
#define MARGENT 8
#define AVATAR_WIDTH 44
-(void)dealloc{
    [self clearView];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView {
    //容器
    _souceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 0)];
    _souceView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_souceView];
    //头像
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MARGENT, MARGENT, 44, 44)];
    [_souceView addSubview:_photoImageView];
    _photoImageView.layer.cornerRadius = AVATAR_WIDTH / 2;
    //名字
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_photoImageView.frame) + MARGENT, MARGENT + 3, 200, 20)];
    [_souceView addSubview:_userNameLabel];
   //时间
    _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - 100, CGRectGetMinY(_userNameLabel.frame), 100, 20)];
    _timelabel.textColor = [UIColor lightGrayColor];
    _timelabel.font = [UIFont systemFontOfSize:15];
    [_souceView addSubview:_timelabel];
    //内容
    _contantView = [[UILabel alloc]initWithFrame:CGRectMake(MARGENT, 0, VIEW_WIDTH - MARGENT * 2, 10)];
//    _contantView.numberOfLines = 0;
    [_souceView addSubview:_contantView];
    
    //缩略图
    _picUrlsView = [[UIView alloc]initWithFrame:CGRectMake(MARGENT, 0, VIEW_WIDTH - MARGENT * 2, 0)];
    _picUrlsView.backgroundColor = [UIColor clearColor];
    [_souceView addSubview:_picUrlsView];
    
    //地址
    
    _addressButton = [[UIButton alloc]init];
    [_souceView addSubview:_addressButton];
    
    
    //赞
    _prizeButton = [[UIButton alloc]initWithFrame:CGRectMake(MARGENT, MARGENT, 50, 30)];
    
    [_souceView addSubview:_prizeButton];

    _picUrlsArray = [NSMutableArray array];
    
}
-(void)clearView{
    _userNameLabel = nil;
    _contantView = nil;
    _photoImageView = nil;
    _timelabel = nil;
    _addressButton = nil;
    _picUrlsView = nil;
    _prizeButton = nil;
    buttonView = nil;

}
-(void)setcontantWithModel:(CardRecordList *)model cardId:(NSInteger)cardId{
    cardIds = cardId;
    cardModels = model;
    NSInteger Top = MARGENT;
//    _addressButton = nil;
    [_addressButton setTitle:@"" forState:UIControlStateNormal];
//头像
    _photoImageView.frame = CGRectMake(MARGENT, Top, AVATAR_WIDTH, AVATAR_WIDTH);
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    
//时间
//    NSString * timeStr = [Utile getTimeDesc:model.createTime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createTime / 1000];
    NSString * day = [formatter stringFromDate:date];
    
    NSInteger nowTime =[[NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970]] integerValue];
    NSString * Year =[formatter stringFromDate:[NSDate date]];
    NSString * nowYear = [Year substringToIndex:4];
    NSLog(@"得到今年:%@",nowYear);
    NSInteger dis = nowTime - model.createTime / 1000;
    NSLog(@"得到的时间间隔:%ld",(long)dis);
    if (dis <= 60) {
        _timelabel.text = @"刚刚";
    }
   else if (60 < dis && dis <= 3600) {
        NSInteger passTime = dis / 60;
        _timelabel.text = [NSString stringWithFormat:@"%ld分钟前",(long)passTime];
    }
   else if (3600 < dis && dis<= 3600 * 24){
       //两天内
       [formatter setDateFormat:@"YYYY-MM-dd"];
       NSString *needDay = [formatter stringFromDate:date];
       NSString * nowDay = [formatter stringFromDate:[NSDate date]];
       [formatter setDateFormat:@"HH:mm"];
       if ([needDay isEqualToString:nowDay]) {
           _timelabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
       }
       else{
           _timelabel.text = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];

       }
   }
   else if (3600* 24 < dis && dis<= 3600 * 48){
       [formatter setDateFormat:@"YYYY-MM-dd"];
       NSString *needDay = [formatter stringFromDate:date];
       NSString * nowDay = [formatter stringFromDate:[NSDate date]];
       [formatter setDateFormat:@"HH:mm"];
       NSInteger need =[[needDay substringFromIndex:8]integerValue] ;
       NSInteger now = [[nowDay substringFromIndex:8]integerValue] ;
       if (now == need + 1) {
           _timelabel.text = [NSString stringWithFormat:@"昨天 %@",[formatter stringFromDate:date]];
       }
       else{
           _timelabel.text = [NSString stringWithFormat:@"%@",[day substringFromIndex:5]];
       }
   }
   else if (3600* 48< dis &&[nowYear isEqualToString:[day substringToIndex:4]]){
       _timelabel.text = [NSString stringWithFormat:@"%@",[day substringFromIndex:5]];
   
   }
   else{
       _timelabel.text = day;
   
   }
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize Tsize = [_timelabel.text boundingRectWithSize:CGSizeMake(200, 20) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _timelabel.frame = CGRectMake(VIEW_WIDTH - MARGENT - Tsize.width, Top, Tsize.width, 20);
//    _timelabel.text = day;
    
    Top += 20 +MARGENT;
    
//标题
//    if (_userNameLabel) {
//        [_userNameLabel removeFromSuperview];
//    }
    _userNameLabel.frame = CGRectMake(MARGENT * 2 + AVATAR_WIDTH, MARGENT, VIEW_WIDTH - Tsize.width - MARGENT * 4 - AVATAR_WIDTH, 20);
    _userNameLabel.text = model.nickName;
//    [_souceView addSubview:_userNameLabel];
    if (_picUrlsArray) {
        [_picUrlsArray removeAllObjects];
    }
    if (model.clockImg.length > 0) {
        NSArray * array = [Utile changJsonStringToObject:model.clockImg];
        [_picUrlsArray addObjectsFromArray:array];
    }
    NSLog(@"33333数量:%lu",(unsigned long)_picUrlsView.subviews.count);
    for (UIView *subView in _picUrlsView.subviews) {
        //避免重用
        [subView removeFromSuperview];
    }

    Top = [self addText:model.title andPicUrl:_picUrlsArray withiTop:Top withtextView:_contantView  withPicView:_picUrlsView];
    Top += MARGENT;
    
    if (model.isPosition == 0) {
        //显示地理位置
        [_addressButton setTitle:model.position forState:UIControlStateNormal];
        [_addressButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _addressButton.enabled = NO;
        [_addressButton setImage:[UIImage imageNamed:@"place_press"] forState:UIControlStateNormal];
        _addressButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _addressButton.frame = CGRectMake(MARGENT, Top , 100, 20);
        Top += 20 + MARGENT;
    }
    else{
         _addressButton.frame = CGRectMake(MARGENT, Top , 200, 0);
    }
    if (self.lineLabel) {
        [self.lineLabel removeFromSuperview];
    }
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Top, VIEW_WIDTH, 0.5)];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    [_souceView addSubview:_lineLabel];
    
    Top += MARGENT;
    
    _prizeButton.frame = CGRectMake(VIEW_WIDTH- 80, Top, 80, 30);
    [_prizeButton setTitle:[NSString stringWithFormat:@"%ld",(long)model.likes] forState:UIControlStateNormal];
    if (model.isLike == 0) {
        //已经赞
       [_prizeButton setImage:[UIImage imageNamed:@"praise_press"] forState:UIControlStateNormal];
        [_prizeButton setTitleColor:[Utile orange] forState:UIControlStateNormal];
//        _prizeButton.titleLabel.textColor =[Utile orange];
        _prizeButton.enabled = NO;
    }
    else{
        [_prizeButton setImage:[UIImage imageNamed:@"praise_normal"] forState:UIControlStateNormal];
        [_prizeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        _prizeButton.titleLabel.textColor =[Utile background];
        _prizeButton.enabled = YES;
    }
     [_prizeButton addTarget:self action:@selector(addLikeCount) forControlEvents:UIControlEventTouchUpInside];
    Top += 30 + 2;
    
    UIButton * imageButton = [[UIButton alloc]initWithFrame:_photoImageView.frame];
    [imageButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [_souceView addSubview:imageButton];
    _souceView.frame = CGRectMake(0, 0, VIEW_WIDTH, Top);
    

}
-(void)showInfo{
    if ([self.delegate respondsToSelector:@selector(showInfoWithUserId:)]) {
        [self.delegate showInfoWithUserId:cardModels.userId];
    }
    
}
-(NSInteger)addText:(NSString *)textStr andPicUrl:(NSArray *)picUrlsArray withiTop:(NSInteger)iTop withtextView:(UILabel*)textView withPicView:(UIView*)picView {
    //内容
    CGFloat contentH = VIEW_WIDTH - MARGENT * 3 - AVATAR_WIDTH;
     NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
 CGSize Hsize = [textStr boundingRectWithSize:CGSizeMake(contentH, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor lightGrayColor];
    textView.frame = CGRectMake( AVATAR_WIDTH+ 2* MARGENT, iTop, contentH, Hsize.height);
    textView.text = textStr;
    
    textView.numberOfLines = 0;
    
    iTop += Hsize.height + MARGENT;
    
    //缩略图
    int x = PIC_COUNT;
    int num = picUrlsArray.count/PIC_COUNT;
    int hightImage =(VIEW_WIDTH - picUrlsArray.count * PIC_COUNT)/PIC_COUNT;
    if (picUrlsArray && picUrlsArray.count!=0) {
        for (UIView *subView in picView.subviews) {
            //避免重用
            [subView removeFromSuperview];
        }
        picView.frame = CGRectMake(0, iTop, VIEW_WIDTH, hightImage);
        //算出高度
        iTop += ((num+1)*(hightImage));
        
        if (picUrlsArray.count%PIC_COUNT == 0) {
            iTop -=hightImage+PIC_COUNT;
        }
        buttonView.frame = CGRectMake(0, 0, 0, 0);
        [buttonView removeFromSuperview];
        for (int i=0; i<picUrlsArray.count; i++) {
            //            [picView addSubview:imageView];
            buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(x, (i/PIC_COUNT)*(hightImage+PIC_COUNT), hightImage, hightImage)];
            buttonView.tag = i;
            buttonView.userInteractionEnabled = YES;
            [buttonView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",picUrlsArray[i]]]];
            UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            tap.numberOfTapsRequired = 1;
            [buttonView addGestureRecognizer:tap];
            
            x+=hightImage+PIC_COUNT;
            if ((i+1)%PIC_COUNT == 0) {
                x = 0;
            }
            [picView addSubview:buttonView];
        }
    }
    
    return iTop;
}
-(void)show:(UIButton*)button {
    NSLog(@"点击了第%ld图片",(long)button.tag);
    [SJAvatarBrowser showImage:button.imageView];
}

-(void)magnifyImage:(UITapGestureRecognizer*) gesture
{
    NSLog(@"局部放大");
    UIImageView *view = (UIImageView*)gesture.view;
    [SJAvatarBrowser showImage:view];//调用方法
    
}
-(void)addLikeCount{
    if ([[UserDao sharedInstance]loadUser].userId < 1) {
        if ([self.delegate respondsToSelector:@selector(addLikeResultLogin)]){
            [self.delegate addLikeResultLogin];
        }
    }
    LikeApi * api = [[LikeApi alloc]init];
    api.userId = [[UserDao sharedInstance ]loadUser].userId;
    api.cardId = cardIds;
    api.recordId = cardModels.recordId;
    MBProgressHUD * hud = [Utile showHudInView:self];
    [api executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
            //赞成功
            [_prizeButton setImage:[UIImage imageNamed:@"praise_press"] forState:UIControlStateNormal];
            [_prizeButton setTitleColor:[Utile orange] forState:UIControlStateNormal];
            NSInteger counnt = [_prizeButton.titleLabel.text integerValue] + 1;
            [_prizeButton setTitle:[NSString stringWithFormat:@"%ld",(long)counnt] forState:UIControlStateNormal];
            [self showAnimationWithLayer:_prizeButton.layer];
            _prizeButton.enabled = NO;
        }
        else if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"1"]){
            [Utile showWZHUDWithView:self andString:@"赞失败了喔~~"];
        
        }
        
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
}
-(void)showAnimationWithLayer:(CALayer*)layer{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.duration = 0.5;
    [layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}
+(NSInteger)heightWithModel:(CardRecordList*)model{
    NSInteger iTop = 0;
    
    iTop += 20 + MARGENT*2 ;
    NSMutableArray * arr = [NSMutableArray array];
    if (model.clockImg.length > 0) {
        NSArray * array = [Utile changJsonStringToObject:model.clockImg];
        [arr addObjectsFromArray:array];
    }
    iTop += [self heightText:model.title withpicArray:arr];
    
    if (model.isPosition == 0) {
        //显示地址
     return  iTop += 20 + MARGENT *2 + 30 + 2;
    }
    iTop +=  MARGENT + 30 + 2;
    return iTop;
//加2距离

}
+(NSInteger)heightText:(NSString*)text withpicArray:(NSArray*)picArray
{
    CGFloat contentH = VIEW_WIDTH - MARGENT * 3 - AVATAR_WIDTH;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
    CGSize Hsize = [text boundingRectWithSize:CGSizeMake(contentH, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    NSInteger height = Hsize.height;
    height += MARGENT;
    
    //图片是否有
    int num = picArray.count/PIC_COUNT;
    int hightImage = (VIEW_WIDTH - MARGENT)/PIC_COUNT;
    if (picArray && picArray.count!=0) {
        height +=((num+1)*(hightImage));
        if (picArray.count%PIC_COUNT == 0) {
            height -=hightImage+PIC_COUNT;
        }
    }
    return height ;
}

//
//-(void)dealloc{
//    _userNameLabel = nil;
//    
//
//}



@end
