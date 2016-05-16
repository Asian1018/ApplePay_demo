//
//  LoginViewController.m
//  colorRun
//
//  Created by engine on 15/11/5.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "CoolApi.h"
#import "User.h"
#import "UMSocial.h"
#import "UserDao.h"
#import "MineViewController.h"
#import <CoreLocation/CoreLocation.h>
//#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface LoginViewController ()<CLLocationManagerDelegate,UITextFieldDelegate>{
    NSString* cityName;
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *qqLogin;
@property (weak, nonatomic) IBOutlet UIButton *weChatLogin;
@property (weak, nonatomic) IBOutlet UIButton *sinaLogin;
@property (nonatomic , strong)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

#define TEST_NAME @"lhda@y6.cn"
#define TEST_PASSWORD @"123456"
@implementation LoginViewController
- (void)locate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
    // 开始定位
   // [_locationManager startUpdatingLocation];
}
-(NSString*)getAddressString{
    if (cityName.length > 0) {
        return cityName;
    }
    return @"广东省广州市";
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (cityName) {
        return;
    }
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = @"";
             if (!placemark.locality) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             if (placemark.administrativeArea) {
                 city = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
             }
             cityName = city;
              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setObject:city forKey:@"location"];
             [userDefaults synchronize] ;
             NSLog(@"定位完成:%@",cityName);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}
//- (void)keyboardWillShow:(NSNotification *)notif {
//    if (self.hidden == YES) {
//        return;
//    }
//    
//    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat y = rect.origin.y;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.25];
//    NSArray *subviews = [self subviews];
//    for (UIView *sub in subviews) {
//        
//        CGFloat maxY = CGRectGetMaxY(sub.frame);
//        if (maxY > y - 2) {
//            sub.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, sub.center.y - maxY + y - 2);
//        }
//    }
//    [UIView commitAnimations];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
    [self locate];
    //所有第三方APP是否有装
    /*
    if (![QQApiInterface isQQInstalled]) {
        self.qqLogin.hidden = YES;
        
    }
    if (![WXApi isWXAppInstalled]) {
        self.weChatLogin.hidden = YES;
    }
    if (![WeiboSDK isWeiboAppInstalled]) {
        self.sinaLogin.hidden = YES;
    }*/
    self.nameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    // Do any additional setup after loading the view.
    [[self rdv_tabBarController] setTabBarHidden:YES];
}

-(void) testTrack{

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
   
   User* user = [[UserDao sharedInstance]loadUser];
    if (user==nil) {
        _loginButton.layer.borderColor=[Utile green].CGColor;
        _loginButton.layer.borderWidth=1 ;
        [_loginButton setTitleColor:[Utile green] forState:UIControlStateNormal];
    }else {
        [self dismissViewControllerAnimated:YES
                            completion:^{
                                
                            }] ;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTextField) {
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    [self.passwordTextField resignFirstResponder];
    return YES;
    
}
#pragma mark - 屏幕上弹
-( void )textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘高度216
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y + textField.frame.size.height + 216 + 50);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

#pragma mark -屏幕恢复
-( void )textFieldDidEndEditing:(UITextField *)textField
{
    //滑动效果
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)qqLogin:(UIButton *)sender {
    [self snsLogin:2] ;
}


-(void) snsLogin:(NSInteger) type{
    NSArray* snsPlatformArray=@[UMShareToSina,UMShareToQQ,UMShareToWechatSession];
    NSString* sns = [snsPlatformArray objectAtIndex:type-1];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:sns];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:sns];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [[UMSocialDataService defaultDataService] requestSnsInformation:sns  completion:^(UMSocialResponseEntity *response){
                NSLog(@"SnsInformation is %@",response.data);
                [self loginBySNS:response
                      snsAccount:snsAccount
                            type:type] ;
            }];
            
        }});
}

-(void) loginBySNS:(UMSocialResponseEntity*) response snsAccount:(UMSocialAccountEntity*) snsAccount type:(NSInteger) type{

    LoginApi* api = [[LoginApi alloc]init] ;
    api.clientType=2 ;
    UIDevice *device =[[UIDevice alloc]init] ;
    api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    api.oauthId = snsAccount.usid;
    api.oauthType = type ;
    api.nickName = snsAccount.userName;
    api.avatar = snsAccount.iconURL ;
    //            api.deviceToken = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_TOKEN]) {
        api.deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_TOKEN] ;
    }
    api.position=[self getAddressString];
    //1 : wb 2 : qq 3 : wx
    //            api.birthday = @"未知时间";
    NSDictionary* dict = [response.data valueForKey:@"wxsession"];
    if ([dict valueForKey:@"birthday"]) {
        api.birthday=[dict valueForKey:@"birthday"];
    }
    if (type==2) {
        NSString* gender = response.data[@"gender"] ;
        if ([gender isEqualToString:@"男"]) {
            api.sex=@"1" ;
        }else if([gender isEqualToString:@"女"]){
            api.sex=@"2" ;
        }else{
            api.sex= @"0" ;//未知性别.取不到
        }
    }else if(type==1||type==3){
        if ([response.data[@"gender"] isEqualToNumber:@0]) {
            api.sex=@"2" ;
        }else{
            api.sex=@"1" ;
        }
    }
   
    MBProgressHUD * hud = [Utile showHudInView:self.view];
    [api excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        NSLog(@"%@",responseDate) ;
        NSString* code =  [responseDate valueForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary* data = [responseDate objectForKey:@"data"] ;
            User* user = [[User alloc]init] ;
            for (id key in [user PropertyKeys]) {
                if ([[data valueForKey:key] isKindOfClass:[NSNumber class]]) {
                    [user setValue:[NSString stringWithFormat:@"%@",[data valueForKey:key]] forKey:key];
                }
                else{
                    [user setValue:[data valueForKey:key] forKey:key] ;
                }
                
            }
            user.kilometers = @"0.0";
            user.periods = @"00:00:00";
            user.oauthType= type ;
            user.remind = @"";
            user.signature = @"";
            user.position = @"";
            UserDao* dao = [UserDao sharedInstance] ;
            [dao insert:user] ;
//            if (user!=nil) {
//                [[NSUserDefaults standardUserDefaults] setValue:user.userId forKey:USER_ID];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }
          [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.delegate respondsToSelector:@selector(refreshViewInfo)]) {
                    [self.delegate refreshViewInfo];
                }
            }];
        }
        else{
            //code 1 2
            [Utile showPromptAlertWithString:@"网络请求出错,请稍后再试"];
            
        }
        
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        NSLog(@"error %@",error.description) ;
        [Utile showPromptAlertWithString:error.description];
        hud.hidden = YES;
    }] ;

    
}

- (IBAction)weChatLogin:(id)sender {
    [self snsLogin:3] ;
}
-(void)setLoginWith:(UMSocialAccountEntity*)snsAccount respon:(UMSocialResponseEntity*)response oauthType:(NSInteger)oauthType{
    
}
//1 : wb 2 : qq 3 : wx
- (IBAction)sinaLogin:(id)sender {
    [self snsLogin:1] ;
}
- (IBAction)loginButtonClicked:(id)sender {
    UserbehaviorApi* api= [[UserbehaviorApi alloc]init] ;
    api.type=0 ;
    api.behavior=0;
      UIDevice *device =[[UIDevice alloc]init] ;
    api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;

    [api executeHasParse:^(id jsonData) {
        
    } failure:^(NSString *error) {
        
    }];
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    ResetPasswordViewController *resetPassword=[borad instantiateViewControllerWithIdentifier:@"checkCodeController"] ;
    resetPassword.type=0 ;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:resetPassword animated:YES] ;

}

- (IBAction)loginHere:(UIButton *)sender {
   
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    PhoneLoginViewController *phoneLoginController=[borad instantiateViewControllerWithIdentifier:@"phoneLoginViewController"] ;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:phoneLoginController animated:YES] ;

}









@end
