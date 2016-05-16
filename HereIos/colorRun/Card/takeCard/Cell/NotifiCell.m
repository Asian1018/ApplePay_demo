
#import "NotifiCell.h"
#import "UIImageView+WebCache.h"
@implementation NotifiCell{
    GroupList* list;

}

- (void)awakeFromNib {
    [self.notiButton setTitle:@"已关注" forState:UIControlStateDisabled];
//    [self.notiButton setBackgroundColor:[Utile green]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fillUIWith:(GroupList *)model{
    
    list = model;
    self.name.text = model.nickName;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
}
-(void)fillUIWith:(GroupList *)model relation:(NSInteger)relation{
    
    list = model;
    self.name.text = model.nickName;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    if (relation == 1) {
        //已关注
        [self.notiButton setBackgroundColor:[UIColor lightGrayColor]];
         self.notiButton.enabled = NO;
    }
    else if (relation == 2) {
        [self.notiButton setBackgroundColor:[UIColor lightGrayColor]];
        self.notiButton.enabled = NO;
    }
    else if (relation == 0) {
        [self.notiButton setBackgroundColor:[Utile green]];
        self.notiButton.enabled = YES;
    }
    
}

- (IBAction)notiAction:(id)sender {
//    [self.notiButton setBackgroundColor:[UIColor lightGrayColor]];
//    self.notiButton.enabled = NO;
    if ([self.delegate respondsToSelector:@selector(notiWith:cell:)]) {
        [self.delegate notiWith:list.userId cell:self];
    }
}
@end
