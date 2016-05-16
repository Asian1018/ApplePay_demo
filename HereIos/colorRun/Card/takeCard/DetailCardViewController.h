
#import <UIKit/UIKit.h>

@interface DetailCardViewController : PageTableViewController
@property(nonatomic) NSInteger cardId;
@property(nonatomic) NSInteger cardType;
@property(nonatomic,strong) NSString * fromType;//不为空的时候返回上层,其他时候返回首页
@end
