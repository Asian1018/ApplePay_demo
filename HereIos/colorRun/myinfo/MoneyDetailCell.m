

#import "MoneyDetailCell.h"

@implementation MoneyDetailCell

- (void)awakeFromNib {
    // Initialization code
    self.moneyLabel.textColor = [Utile orange];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
