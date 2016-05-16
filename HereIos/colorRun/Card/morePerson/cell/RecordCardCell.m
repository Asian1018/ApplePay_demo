
#import "RecordCardCell.h"

@implementation RecordCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)fillContentWith:(RecommCardList*)list{
    if (list.cardMode == 0) {
        self.titleImageView.image = [UIImage imageNamed:@"card_sports"];
    }
    if (list.isPrize ==1) {
        self.prizeImageView.hidden = YES;
    }
    self.contentLabel.text = list.title;
    self.personCountLabel.text = [NSString stringWithFormat:@"%ld 人参加",(long)list.cardCount];
     NSDictionary* fontDict = @{NSForegroundColorAttributeName:[Utile orange]} ;
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:self.personCountLabel.text];
    [changeText addAttributes:fontDict range:NSMakeRange(0,self.personCountLabel.text.length -3)] ;
    self.self.personCountLabel.attributedText = changeText ;
    
    switch (list.cardType) {
            //0:快捷1:图片2:计步3:跑步
        case 0:
            self.avatar.image = [UIImage imageNamed:@"card_punch"];
            break;
        case 1:
            self.avatar.image = [UIImage imageNamed:@"card_picture"];
            break;
        case 2:
            self.avatar.image = [UIImage imageNamed:@"card_steps"];
            break;
        case 3:
            self.avatar.image = [UIImage imageNamed:@"card_run"];
            break;
        default:
            break;
    }
}
@end
