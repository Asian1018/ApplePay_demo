
#import <UIKit/UIKit.h>

@interface RecordCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *prizeImageView;

-(void)fillContentWith:(RecommCardList*)list;
@end
