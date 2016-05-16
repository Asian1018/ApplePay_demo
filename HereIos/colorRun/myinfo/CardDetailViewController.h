
#import <UIKit/UIKit.h>
#import "CompetitionTableViewCell.h"
#import "MyModel.h"
@interface CardDetailViewController : UITableViewController
@property(nonatomic,strong)MyCard* card;
@property(nonatomic)NSInteger cardId;
@end
