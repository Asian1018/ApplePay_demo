
#import "BackGroundViewController.h"
#import "TotalMileViewController.h"
#import "MatchListViewController.h"
#import "DVSwitch.h"
@interface BackGroundViewController (){
    DVSwitch *third;
}
@property(strong, nonatomic)TotalMileViewController * totalMileController;
@property(strong, nonatomic)MatchListViewController * matchViewController;
@property (strong,nonatomic)UITableViewController *currentVC;
@end

@implementation BackGroundViewController
-(id)initWithKilometers:(NSInteger)userId{
    if (self = [super init]) {
        self.userId = userId;
    }

    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    [self makeTwoSignView];
     [self makeSegmentButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeSegmentButton{
    third = [DVSwitch switchWithStringsArray:@[@"卡片", @"赛事活动"]];
    third.cornerRadius = 0;
    third.clipsToBounds = YES;
    third.frame =CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50);
    third.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:18];
    third.backgroundColor = [UIColor groupTableViewBackgroundColor];
    third.labelTextColorInsideSlider = [Utile green];
    third.labelTextColorOutsideSlider = [UIColor blackColor];
    third.sliderColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel * lableLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(third.frame), self.view.frame.size.width /2, 2)];
    lableLeft.backgroundColor = [Utile green];
    [self.view addSubview:lableLeft];
    UILabel * right = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lableLeft.frame), CGRectGetMinY(lableLeft.frame), self.view.frame.size.width /2, 2)];
    right.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:right];
    
    [self.view addSubview:third];
    __block BackGroundViewController *weakSelf = self;
    [third setPressedHandler:^(NSUInteger index) {
        if (index == 0) {
            [weakSelf transitionFromViewController:weakSelf.currentVC toViewController:weakSelf.totalMileController duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                if (finished) {
                    lableLeft.backgroundColor = [Utile green];
                    right.backgroundColor = [UIColor lightGrayColor];
                    weakSelf.currentVC = weakSelf.totalMileController;
                }
                
            }];
            
        }
        else if (index == 1) {
            [weakSelf transitionFromViewController:weakSelf.currentVC toViewController:weakSelf.matchViewController duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            } completion:^(BOOL finished) {
                if (finished) {
                    lableLeft.backgroundColor = [UIColor lightGrayColor];
                    right.backgroundColor = [Utile green];
                    weakSelf.currentVC = weakSelf.matchViewController;
                }
            }];
        }
    }];
    
}

-(void)makeTwoSignView {
    if (!self.matchViewController) {
        self.matchViewController = [[MatchListViewController alloc]initWithStyle:UITableViewStylePlain];
        self.matchViewController.userId = self.userId;
//        self.matchViewController.tableView.backgroundColor = [UIColor blueColor];
        self.matchViewController.tableView.frame = CGRectMake(0, 52, self.view.frame.size.width, self.view.frame.size.height - 50);
        [self.matchViewController removeFromParentViewController];
        [self.view addSubview:self.matchViewController.view];
        [self addChildViewController:self.matchViewController];
    }
    if (!self.totalMileController) {
        self.totalMileController = [[TotalMileViewController alloc]initWithUserId:self.userId];
//        self.totalMileController.kilometers = self.kilometers;
        self.totalMileController.view.frame = CGRectMake(0, 52, self.view.frame.size.width, self.view.frame.size.height - 50);
        self.totalMileController.userId = self.userId;
         [self.totalMileController removeFromParentViewController];
        [self.view addSubview:self.totalMileController.view];
        [self addChildViewController:self.totalMileController];
        _currentVC = self.totalMileController;
    }
    
}

@end
