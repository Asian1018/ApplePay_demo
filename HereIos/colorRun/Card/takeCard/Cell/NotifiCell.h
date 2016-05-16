
#import <UIKit/UIKit.h>
@class NotifiCell;
@protocol NotifiCellDelegate <NSObject>

-(void)notiWith:(NSInteger)followUserId cell:(NotifiCell*)cell;

@end


@interface NotifiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *notiButton;
@property(weak,nonatomic) id<NotifiCellDelegate>delegate;
-(void)fillUIWith:(GroupList*)model relation:(NSInteger)relation;
-(void)fillUIWith:(GroupList*)model;
@end
