
#import <UIKit/UIKit.h>

@interface TakeCardViewController : UIViewController
@property(nonatomic,strong) CardShareData * takeCardApi;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic) NSInteger cardType;
@property(nonatomic) NSInteger userDays;
@end
