#import "RDVTabBarController.h"
#import "MyNewsViewController.h"
#import "InteractListViewController.h"
#import "NewsDetailViewController.h"
@interface MyNewsViewController ()
@property(nonatomic,strong)NewsDetailViewController * interView;
@property(nonatomic,strong)InteractListViewController* newsView;
@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
   NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:@"互动",@"通知", nil];
    UISegmentedControl *segmentController = [[UISegmentedControl alloc]initWithItems:array];
    //segmentController.segmentedControlStyle = UISegmentedControlSegmentCenter;
    CGRect frame = segmentController.frame;
    frame.size.width = 150;
    segmentController.frame = frame;
    [segmentController addTarget:self action:@selector(clickedSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentController;
    //定义初始segment的选择index 。。。这里是默认公开咨询
    segmentController.selectedSegmentIndex = 0;
    if (self.interView== nil) {
        self.interView = [[NewsDetailViewController alloc] init];
        [self addChildViewController:self.interView];
        [self.view addSubview:self.interView.view];
        [self.interView didMoveToParentViewController:self];
//        self.interView.tableView.frame = self.view.frame;
        
        self.interView.tableView.frame = CGRectMake(self.interView.tableView.frame.origin.x,self.interView.tableView.frame.origin.y-20,self.interView.tableView.frame.size.width,self.interView.tableView.frame.size.height+20);
    }
    if (self.newsView == nil) {
        self.newsView = [[InteractListViewController alloc] init];
        [self.view addSubview:self.newsView.view];
        [self addChildViewController:self.newsView];
        [self.newsView didMoveToParentViewController:self];
//        self.newsView.tableView.frame = self.view.frame;
        self.newsView.tableView.frame = CGRectMake(self.newsView.tableView.frame.origin.x,self.newsView.tableView.frame.origin.y+40,self.newsView.tableView.frame.size.width,self.newsView.tableView.frame.size.height+-40);
        
    }

    
    
    
    
}


- (void)clickedSegmentAction:(UISegmentedControl *)segmentController {
    // NSLog(@"%d",segmentController.selectedSegmentIndex);
    
    if (segmentController.selectedSegmentIndex == 1) {
        
        [self transitionFromViewController:self.newsView toViewController:self.interView duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
    else if (segmentController.selectedSegmentIndex == 0) {
        [self transitionFromViewController:self.interView toViewController:self.newsView duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;

}




@end
