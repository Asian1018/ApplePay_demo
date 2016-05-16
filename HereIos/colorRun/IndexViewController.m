//
//  IndexViewController.m
//  colorRun
//
//  Created by engine on 15/10/20.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "IndexViewController.h"
#import "JT3DScrollView.h"
#import "RDVTabBarController.h"
#import "User.h"
#import "CoolApi.h"
#import "Masonry.h"
#import "ActivityDetailTableViewController.h"
#import "O2OWebViewController.h"
@interface IndexViewController (){
    UILabel * errorLabel;
    UIButton * errorButton;
    MBProgressHUD * hud;

}
//@property (weak, nonatomic) IBOutlet JT3DScrollView *scrollView;
@property(nonatomic,strong) JT3DScrollView *scrollView ;
@property (nonatomic,strong) NSMutableArray* activtyArray  ;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary* titleDict =@{NSForegroundColorAttributeName:[Utile contentBlack]} ;
    self.navigationController.navigationBar.titleTextAttributes=titleDict ;
    _activtyArray=[NSMutableArray array] ;
    self.automaticallyAdjustsScrollViewInsets=NO ;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bg"] forBarMetrics:UIBarMetricsDefault] ;
    [self getData] ;
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 64, self.view.frame.size.width, 2);
    label.backgroundColor = [Utile background];
    [self.view addSubview:label];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO] ;
}

-(void) getData{
    CoolActivityList* getCoolList = [[CoolActivityList alloc]init] ;
    User* user = [[UserDao sharedInstance]loadUser] ;
    if (user) {
        getCoolList.userId=user.userId ;
    }
    hud = [Utile showHudInView:self.navigationController.view];
    [getCoolList executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        for (id item in jsonData) {
            Activity* activity = [Activity initWithJSON:item] ;
            [_activtyArray addObject:activity];
        }
        if(self.scrollView.subviews.count!=_activtyArray.count){
            self.scrollView.effect=JT3DScrollViewEffectTranslation ;
            for (Activity* act in _activtyArray) {
                [self createCustomViewWithModel:act];
            }
        }
        
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [self setHomePageFailAction];
        errorButton.hidden = NO;
        errorLabel.hidden = NO;
        
    }];
}
-(void)setHomePageFailAction{
    if (!errorLabel) {
        CGFloat Width = CGRectGetWidth(self.view.frame);
        CGFloat height = CGRectGetHeight(self.view.frame);
        errorLabel = [[UILabel alloc]init];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.text = @"亲,网络不给力啊!!";
        //    errorLabel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        errorLabel.frame = CGRectMake(Width / 2 - 100, height / 2 - 50, 200, 30);
        errorLabel.textColor = [Utile green];
        [self.view addSubview:errorLabel];
    }
    if (!errorButton) {
        errorButton  = [[UIButton alloc]initWithFrame:CGRectMake(errorLabel.frame.origin.x, CGRectGetMaxY(errorLabel.frame) + 10, 200, 40)];
        errorButton.backgroundColor = [Utile green];
        errorButton.tintColor = [UIColor whiteColor];
        errorButton.layer.cornerRadius = 5;
        errorButton.clipsToBounds = YES;
        [errorButton setTitle:@"再试一下~~" forState:UIControlStateNormal];
        [self.view addSubview:errorButton];
        [errorButton addTarget:self action:@selector(loadAgain) forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void)loadAgain{
    errorButton.hidden = YES;
    errorLabel.hidden = YES;
    [self getData];
}
-(void) onActivityClick:(Activity *)model{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    if (model.type==2) {
        NSString* viewControllerTag = @"activityDetail" ;
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ActivityDetailTableViewController *controller=[borad instantiateViewControllerWithIdentifier:viewControllerTag] ;
//        ActivityDetailTableViewController* controller = [[ActivityDetailTableViewController alloc]init];
        controller.aId=model.activityId ;
//        [Utile setLocationNoti:@"测试本地通知" userinfos:nil];
        [self.navigationController pushViewController:controller animated:YES] ;
    }else if(model.type==1){
        NSLog(@"o2o活动");
        O2OWebViewController * web = [[O2OWebViewController alloc]init];
        if (model.o2oUrl.length > 0) {
            web.o2oUrl = model.o2oUrl;
            [self.navigationController pushViewController:web animated:YES];
//            [Utile showWZHUDWithView:self.navigationController.view andString:@"这是O2O活动"];
            return;
        }
        [Utile showWZHUDWithView:self.navigationController.view andString:@"这是O2O活动,暂不开通"];
    }else{
        NSLog(@"未知类型=%lu",model.type) ;
    }
}

-(void) createCustomViewWithModel:(Activity*) model{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat height = CGRectGetHeight(self.scrollView.frame) ;
    CGFloat x = self.scrollView.subviews.count*width ;
    CoolItemView* item = [CoolItemView initCoolItemView:CGRectMake(x, 0, width, height) whithModel:model] ;
    //    item.layer.cornerRadius=8.0;
    item.delegate=self ;
    [self.scrollView addSubview:item] ;
    self.scrollView.contentSize= CGSizeMake(x+width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
