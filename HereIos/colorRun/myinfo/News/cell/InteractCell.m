
#import "InteractCell.h"
#import "UIImageView+WebCache.h"
@implementation InteractCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)creatImageViewWith:(NSArray*)arr{
    CGFloat margent = 6;
    CGFloat width = 30;
    for (int i = 0; i < arr.count; i++) {
        UIImageView * view = [[UIImageView alloc]init];
        view.frame = CGRectMake(i*(width + margent), 2, width, width);
        view.layer.cornerRadius = width /2;
        view.clipsToBounds = YES;
        [view sd_setImageWithURL:[NSURL URLWithString:[arr objectAtIndex:i]] placeholderImage:nil];
        [self.personView addSubview:view];
    }

}
-(void)fillUIWith:(InteractList*)model{
    self.titleLabel.text = model.msgTitle;
    self.contendLabel.text = model.msgDewrite;
    if (model.createTime > 0) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createTime / 1000];
        NSString * day = [formatter stringFromDate:date];
        self.timeLabel.text = day;
    }
//    NSArray * arr = [Utile changJsonStringToObject:model.msgAvatar];
//    NSLog(@"得到的头像数组:%@",model.msgAvatar);
    NSArray * arr = [model.msgAvatar componentsSeparatedByString:@","];
    if (arr.count > 0) {
        [self creatImageViewWith:arr];
    }
    
    

}
@end
