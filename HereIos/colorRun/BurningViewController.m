//
//  BurningViewController.m
//  colorRun
//
//  Created by engine on 15/10/30.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BurningViewController.h"
#import "FastAnimationWithPOP/FastAnimationWithPop.h"
//#import "UMSocial_Sdk_4.3/Header/UMSocial.h"
#import "RunMapsViewController.h"
#import "RDVTabBarController.h"
#import "PersonInfoViewController.h"
#import "LoginViewController.h"
@interface BurningViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property (weak, nonatomic) IBOutlet UIButton *workButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation BurningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _runButton.startAnimationWhenAwakeFromNib=NO ;
    _workButton.startAnimationWhenAwakeFromNib=NO ;
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_runButton startFAAnimation] ;
    [_workButton startFAAnimation] ;
    _runButton.hidden=NO ;
    _workButton.hidden=NO;
    if (self.view.frame.size.height < 490) {
        //4s屏幕
        self.top.constant = 16;
        [self.view updateConstraints];
    }
}


-(void)pushMapViewWithMode:(NSInteger)mode{
    User * user = [[UserDao sharedInstance]loadUser];
    if (user== nil) {
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
        //    loginController.delegate = self;
        [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
        return;
    }
    self.navigationController.navigationBarHidden = NO;
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"CoolMap" bundle:[NSBundle mainBundle]];
    RunMapsViewController *run = [borad instantiateViewControllerWithIdentifier:NSStringFromClass([RunMapsViewController class])] ;
    run.sportMode = mode;
    run.sportType = 0;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:run animated:YES] ;


}
- (IBAction)goWork:(id)sender {
    [self pushMapViewWithMode:0];
}
- (IBAction)running:(UIButton *)sender {
    [self pushMapViewWithMode:1];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[self rdv_tabBarController] setTabBarHidden:NO] ;
}
-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _runButton.hidden=YES ;
    _workButton.hidden=YES ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
