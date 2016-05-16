
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class InviteCell;
@protocol InviteCellDelegate <NSObject>

-(void)choosePersonAction:(GroupList*)list cell:(InviteCell*)cell;

@end

@interface InviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *choiceButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak,nonatomic) id<InviteCellDelegate>delegate;
-(void)setUIWith:(GroupList*)list;
@end
