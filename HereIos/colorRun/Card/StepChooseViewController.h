
#import <UIKit/UIKit.h>

@class StepChooseViewController;
@protocol StepChooseViewControllerDelegate <NSObject>

-(void)getResultStepWithCount:(NSString*)count ;

@end
@interface StepChooseViewController : UIViewController

@property(weak, nonatomic) id<StepChooseViewControllerDelegate>delegate;
@property(nonatomic) NSInteger sportType;//类型 2:计步  3:跑步

@end
