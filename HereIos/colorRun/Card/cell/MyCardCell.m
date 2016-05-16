
#import "MyCardCell.h"

@implementation MyCardCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel.layer.cornerRadius = 10;
    self.typeLabel.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)signCardButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(signCardAction:)]) {
        [self.delegate signCardAction:self];
    }
}

-(void)fillCellWithModel:(MyCardListModel*)model{
    [self.signCardButton setImage:[UIImage imageNamed:@"register_press"] forState:UIControlStateDisabled];
    if (model.cardMode == 0) {
        self.cardTypeImageView.image = [UIImage imageNamed:@"card_sports"];
    }
    else{
        self.cardTypeImageView.image = [UIImage imageNamed:@"card_play"];
    }
    
    if (model.broadcast == 1) {
        self.typeLabel.text = @"个人";
    }
    else{
        self.typeLabel.text = @"广播";
    }
    self.titleLabel.text = model.title;
    self.dayLabel.text = [NSString stringWithFormat:@"坚持%ld天",(long)model.days];
    self.personLabel.text = [NSString stringWithFormat:@"%ld人",(long)model.cardCount];
    NSString * str = @"创建";
    if (model.createCard == 1) {
        str = @"加入";
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",model.createTime,str];
    if (model.clockStatus == 1) {
         self.signCardButton.enabled = NO;
    }
    else {
        self.signCardButton.enabled = YES;
    }
    switch (model.cardType) {
            //0:快捷1:图片2:计步3:跑步
        case 0:
            self.categoryImageview.image = [UIImage imageNamed:@"card_punch"];
            break;
        case 1:
            self.categoryImageview.image = [UIImage imageNamed:@"card_picture"];
            break;
        case 2:
            self.categoryImageview.image = [UIImage imageNamed:@"card_steps"];
            break;
        case 3:
            self.categoryImageview.image = [UIImage imageNamed:@"card_run"];
            break;
        default:
            break;
    }

    
}


@end
