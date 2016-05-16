
#import "CreatCardFirstViewController.h"
#import "RDVTabBarController.h"
#import "CreatCardSecondViewController.h"
#import "LoginViewController.h"
@interface CreatCardFirstViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *sportButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeButton;
@property(strong , nonatomic) UIButton *selectedButton;
@end

@implementation CreatCardFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sportButton.layer.cornerRadius = self.sportButton.frame.size.height / 2;
    self.lifeButton.layer.cornerRadius = self.sportButton.frame.size.height / 2;
    
    [self.sportButton setBackgroundImage:[UIImage imageNamed:@"card_target_press"] forState:UIControlStateSelected];
    [self.lifeButton setBackgroundImage:[UIImage imageNamed:@"card_play_press"] forState:UIControlStateSelected];
    self.cardApi = [[CreateCard alloc]init];
    self.nextStepButton.enabled = NO;
    
    
    
}

- (IBAction)selectedCardType:(UIButton *)sender {
    if ([[UserDao sharedInstance]loadUser].userId < 1) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    self.cardApi.userId = [[UserDao sharedInstance]loadUser].userId  ;
    self.nextStepButton.enabled = YES;
    [self.nextStepButton setBackgroundColor:[Utile green]];
    if(sender != self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = sender;
        self.cardApi.cardMode = sender.tag;
        NSLog(@"选择的运动类型:%ld",(long)sender.tag);
    }
    self.selectedButton.selected=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}


- (IBAction)cancleAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showNextStep:(id)sender {
   [self performSegueWithIdentifier:@"showSecondIndent" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showSecondIndent"]) {
        CreatCardSecondViewController * second = segue.destinationViewController;
        second.cardApi = self.cardApi;
        NSLog(@"这里传参数:类型是：%ld",(long)second.cardApi.cardMode);
    }
}


@end
