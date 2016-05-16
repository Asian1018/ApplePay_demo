
#import "HeaderView.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
@implementation HeaderView

-(id)init{
    if (self = [super init]) {
        [self creatHeaderView];
    }

    return self;

}


-(void)creatHeaderView{
    CGFloat margent = 8;
    self.backgroundColor = [UIColor whiteColor];
    
    self.avatarButton = [[UIButton alloc]init];
    self.avatarButton.frame = CGRectMake(8, 8, 50, 50);
    self.avatarButton.layer.cornerRadius = 25;
    self.avatarButton.clipsToBounds = YES;
    [self.avatarButton setImage:[UIImage imageNamed:@"my_voucher" ] forState:UIControlStateNormal];
    [self.avatarButton addTarget:self action:@selector(showMyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.avatarButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarButton.frame.origin.y + 50 + margent, margent, 150, 20)];
    self.nameLabel.text = @"----";
    [self addSubview:self.nameLabel];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.frame = CGRectMake(_avatarButton.frame.origin.y + 50 + margent, CGRectGetMaxY(_avatarButton.frame) - 16, 150, 16);
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = [UIColor lightGrayColor];
    _addressLabel.text = @"广东省-广州市";
    [self addSubview:_addressLabel];
    
    _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH - margent - 120, CGRectGetMidY(_avatarButton.frame) - 10, 120, 20)];
    _dayLabel.text = @"坚持 - 天";
//    _dayLabel.textColor = [Utile orange];
    _dayLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_dayLabel];
    
    self.frame = CGRectMake(0, 0, VIEW_WIDTH, CGRectGetMaxY(_addressLabel.frame) + margent* 2);
    self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(_avatarButton.frame) + margent);
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) -1, CGRectGetWidth(self.frame), 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
}

-(void)showMyInfo{
    if ([self.delegate respondsToSelector:@selector(showMyCardInfo)]) {
        [self.delegate showMyCardInfo];
    }
}

-(void)magnifyImage:(UITapGestureRecognizer*) gesture
{
    NSLog(@"局部放大");
    if (gesture.view) {
        UIImageView *view = (UIImageView*)gesture.view;
        [SJAvatarBrowser showImage:view];//调用方法
    }
}

-(void)fillWithModel:(CardInfoModel*)model{
    [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    self.nameLabel.text = model.nickName;
    self.addressLabel.text = model.position;
    self.dayLabel.text = [NSString stringWithFormat:@"坚持 %ld 天",(long)model.days];
    NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.dayLabel.text];
    [changeText addAttributes:fontDict range:NSMakeRange(2,self.dayLabel.text.length - 3)] ;
   self.dayLabel.attributedText = changeText;
    
    if (model.cardSource ==1) {
        //官方
        self.dayLabel.text = [NSString stringWithFormat:@"累计打卡 %ld 次",(long)model.days];
        NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
        NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.dayLabel.text];
        [changeText addAttributes:fontDict range:NSMakeRange(4,self.dayLabel.text.length - 5)] ;
        self.dayLabel.attributedText = changeText;
        
        
        
        self.addressLabel.hidden = YES;
        CGRect frame = self.nameLabel.frame;
        frame.origin.y = 8 +18;
        self.nameLabel.frame = frame;
        if (model.isReward == 0) {
            //有奖励
            UIImageView * picImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_avatarButton.frame) + 16, 44, 44)];
            if (model.prizeSubPoster.length > 0) {
                [picImage sd_setImageWithURL:[NSURL URLWithString:model.prizePoster] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
            }
            UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            tap.numberOfTapsRequired = 1;
            picImage.userInteractionEnabled = YES;
//            UIImageView * imView = [[UIImageView alloc]init];
//            [imView sd_setImageWithURL:[NSURL URLWithString:model.prizeSubPoster] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
            [picImage addGestureRecognizer:tap];
            
            UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(picImage.frame) + 8, CGRectGetMinY(picImage.frame), VIEW_WIDTH - 24 -44, 25)];
            la.numberOfLines = 1;
            la.text = model.prizeName;
            CGSize msize = [Utile getSizeWithString:model.prizeDetail font:15 width:CGRectGetWidth(la.frame)];
            UILabel * detail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(la.frame), CGRectGetMaxY(la.frame) + 8, CGRectGetWidth(la.frame), msize.height)];
            detail.textColor = [UIColor lightGrayColor];
            detail.numberOfLines = 0;
            detail.text = model.prizeDetail;
            detail.font = [UIFont systemFontOfSize:15];
            [self addSubview:detail];
            [self addSubview:la];
            [self addSubview:picImage];
            CGRect frame = self.frame;
            frame.size.height = CGRectGetMaxY(detail.frame) + 8;
            self.frame = frame;
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 1, VIEW_WIDTH, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
    }
    
    

}
@end
