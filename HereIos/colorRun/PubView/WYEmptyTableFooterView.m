#import "WYEmptyTableFooterView.h"

@implementation WYEmptyTableFooterView

+ (instancetype)emptyTableFooterViewWithTableView:(UITableView *)tableView
{
    WYEmptyTableFooterView *view = [[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:nil options:nil][0];
    
    view.frame = tableView.frame;
    return view;
}

@end