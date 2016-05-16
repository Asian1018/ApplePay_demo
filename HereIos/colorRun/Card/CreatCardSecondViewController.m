
#import "RDVTabBarController.h"
#import "CreatCardSecondViewController.h"
#import "CreatCardThirdViewController.h"
@interface CreatCardSecondViewController ()
@property (weak, nonatomic) IBOutlet UIButton *fastButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *walkButton;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property(strong , nonatomic) UIButton *selectedButton;
@end

@implementation CreatCardSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.enabled = NO;
    [self.fastButton setBackgroundImage:[UIImage imageNamed:@"card_punch_press"] forState:UIControlStateSelected];
    [self.pictureButton setBackgroundImage:[UIImage imageNamed:@"card_picture_press"] forState:UIControlStateSelected];
    [self.walkButton setBackgroundImage:[UIImage imageNamed:@"card_step_press"] forState:UIControlStateSelected];
    [self.runButton setBackgroundImage:[UIImage imageNamed:@"card_run_press"] forState:UIControlStateSelected];
    // Do any additional setup after loading the view.
    if (self.cardApi.cardMode == 1) {
        //生活也要玩
        UIView * view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 280+ 64 , VIEW_WIDTH, 150);
        [self.view addSubview:view];
    }

    
}
//取消按钮
- (IBAction)cancleButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//上一步
- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (IBAction)chooseCardTypeButtonClicked:(UIButton *)sender{
    self.nextButton.enabled = YES;
    [self.nextButton setBackgroundColor:[Utile green]];
    if(sender != self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = sender;
        self.cardApi.cardType = sender.tag;
        NSLog(@"选择类型:%ld",(long)sender.tag);
    }
    self.selectedButton.selected = YES;
    switch (self.cardApi.cardType) {
        case 0:
            self.cardApi.target = 0;
            break;
        case 1:
            self.cardApi.target = 0;
            break;
        case 2:
            self.cardApi.target = 1;
            break;
        case 3:
            self.cardApi.target = 2;
            break;
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showThirdView"]) {
        CreatCardThirdViewController * third = segue.destinationViewController;
        third.cardApi = self.cardApi;
        NSLog(@"这里传参数:类型是：%ld",(long)third.cardApi.cardType);
    }
    
}

- (IBAction)nextStep:(id)sender {
    [self performSegueWithIdentifier:@"showThirdView" sender:nil];
    
}

@end
