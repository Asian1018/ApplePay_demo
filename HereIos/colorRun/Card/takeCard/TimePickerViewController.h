
#import <UIKit/UIKit.h>
@class TimePickerViewController;
@protocol TimePickerViewControllerDelegate <NSObject>

-(void)getResultStepWithCount:(NSInteger)count timeString:(NSString*)time;

@end
@interface TimePickerViewController : UIViewController
@property(weak, nonatomic) id<TimePickerViewControllerDelegate>delegate;
@property(nonatomic) NSInteger qcId;//卡片资格Id
@property(nonatomic) NSInteger isRemind;
@property(nonatomic,strong) NSString * fromType;//有值得时候是加入卡片完成后进来的
@property(nonatomic) NSInteger seconds;//原来设定的时间
@end
