#import <UIKit/UIKit.h>

@interface WYEmptyTableFooterView : UIView

+ (instancetype)emptyTableFooterViewWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playHolderImageView;

@end
