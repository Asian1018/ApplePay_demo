
#import <UIKit/UIKit.h>
@class CardInfoViewController;
@protocol CardInfoViewControllerDelegate <NSObject>

-(void)logoutAction;

@end

@interface CardInfoViewController : UITableViewController
@property(nonatomic) NSInteger cardId;
@property(weak, nonatomic) id<CardInfoViewControllerDelegate>delagate;
@end
