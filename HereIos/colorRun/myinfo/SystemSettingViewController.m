
#import "SystemSettingViewController.h"
#import "RDVTabBarController.h"
#import "UMFeedback.h"
#import "UserAgreementViewController.h"
@interface SystemSettingViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *farwardCell;//求鞭笞
@property (weak, nonatomic) IBOutlet UITableViewCell *aboutCoolCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *menoryCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *healthKitCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *evaluateCell;
@property (weak, nonatomic) IBOutlet UILabel *healthKitLabel;
@property (weak, nonatomic) IBOutlet UILabel *menoryLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *agreementCell;


@end

@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manger = [HealthManager shareInstance];
    self.logoutButton.backgroundColor = [Utile green];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",[self getCach]];
    if ([[UserDao sharedInstance]loadUser] == nil) {
        self.logoutButton.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//退出登录
- (IBAction)logoutButtonClicked:(id)sender {
    //to do
    UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    al.tag = 100;
    [al show];
    
}
#pragma 退出登录
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSLog(@"退出登录");
            [[UserDao sharedInstance]deleteUser];
            //清空本地储存的userid
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == 10){
        if (buttonIndex == 1) {
            //清除缓存
            NSLog(@"清除缓存");
            [self myClearCacheAction];
            
        }
    }

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == self.healthKitCell) {
        self.healthKitLabel.text = @"正在访问健康中心...";
        [_manger getRealTimeStepCountCompletionHandler:^(double value, NSError *error) {
            
            NSLog(@"当天行走步数 = %.0lf",value);
            dispatch_async(dispatch_get_main_queue(), ^(){
                // to do
                self.healthKitLabel.text = @"苹果健康中心同步";
                UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"今天走路步数" message:[NSString stringWithFormat:@"%.0f",value] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [al show];
            });
            
        }];
    }
//    else if (indexPath.row ==0 ){
//        //测试，跳到系统设置页面
//        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//        if ([[UIApplication sharedApplication] canOpenURL:url])
//        {
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    
//    }
    else if (cell == self.evaluateCell ){
        NSString * str = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8",HERE_APPID];
        NSURL * url = [NSURL URLWithString:str];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else{
            [Utile showPromptAlertWithString:@"AppStore miss"];
        }
        
    }
    else if (cell == self.menoryCell){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除缓存吗" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        alert.tag = 10;
        [alert show];
    }
    else if (cell == self.farwardCell){
        [self.navigationController pushViewController:[UMFeedback feedbackViewController]
                                             animated:YES];
    }
    else if (cell == self.agreementCell){
        UserAgreementViewController * ag = [[UserAgreementViewController alloc]
                                            init];
        [self.navigationController pushViewController:ag animated:YES];
    }
    
    
    
}
-(CGFloat)getCach{
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //获取缓存大小。。
    CGFloat fileSize = [self folderSizeAtPath:doc];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"缓存大小:%.2fMB",fileSize);
        
    });
    return fileSize;
}

-(void)myClearCacheAction{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%lu",(unsigned long)[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}


-(void)clearCacheSuccess
{
    [Utile showPromptAlertWithString:@"清理成功"];
    NSLog(@"清理成功");
    
}




- (CGFloat)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
    
}












@end
