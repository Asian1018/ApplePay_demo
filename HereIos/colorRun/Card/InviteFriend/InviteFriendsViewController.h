
#import <UIKit/UIKit.h>
@class InviteFriendsViewController;
@protocol InviteFriendsViewControllerDelegate <NSObject>

-(void)choosenFrindsCount:(NSInteger)count;

@end


@interface InviteFriendsViewController : UITableViewController
//邀请好友页面
@property(nonatomic) NSInteger cardId;
@property(nonatomic,weak) id<InviteFriendsViewControllerDelegate>delegate;
@property(nonatomic,strong)NSString * fromType;
@property(nonatomic,strong) NSString * shareUrl;
@end
