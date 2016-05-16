
#import <UIKit/UIKit.h>
#import "MyModel.h"

@class RewardTableViewCell;
@protocol RewardTableViewCellDelegate<NSObject>

- (void)didClickedGetGitButton:(RewardTableViewCell*)cell;
@end

@interface RewardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *period;
@property (weak, nonatomic) IBOutlet UILabel *pace;
@property (weak, nonatomic) IBOutlet UILabel *bewrite;
@property (weak, nonatomic) IBOutlet UIButton *getGit;

@property (weak, nonatomic) id<RewardTableViewCellDelegate>delegate;

-(void) fillUiWithModel:(MyRewardModel*) modle  ;
@end
