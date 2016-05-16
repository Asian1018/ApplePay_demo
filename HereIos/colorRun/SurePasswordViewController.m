//
//  SurePasswordViewController.m
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "SurePasswordViewController.h"

@interface SurePasswordViewController ()<UITextFieldDelegate>{
    NSArray* titles ;
}

@end

@implementation SurePasswordViewController
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.cornerRadius = 0;
    textField.layer.borderColor = [Utile green].CGColor;
    textField.layer.borderWidth = 1;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.cornerRadius = 0;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    titles =@[@"注册",@"忘记密码",@"绑定手机"] ;
    _password.delegate = self;
    _passwordAgan.delegate = self;
    [StyleUtile initBoundText:_password password:YES needClean:YES];
    [StyleUtile initBoundText:_passwordAgan password:YES needClean:YES] ;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=titles[_type] ;
    switch (self.type) {
        case 1:
            _nextBtn.titleLabel.text=@"修改密码" ;
            break ;
        case 2:
            _nextBtn.titleLabel.text=@"绑定手机" ;
            break ;
        default:
            break;
    }
    
}
-(void) cancel{
    UserbehaviorApi* api = [[UserbehaviorApi alloc]init] ;
    if (_type==0) {
        api.type=0 ;
    }else{
        api.type=1 ;
    }
    api.behavior=2 ;
    UIDevice *device =[[UIDevice alloc]init] ;
    api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;

    [api executeHasParse:^(id jsonData) {
        
    } failure:^(NSString *error) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinHere:(id)sender {
    if ([self validatePassword]) {
        if (_type==0) {
            [self regist] ;
        }else if(_type==1){
            [self modifyPass] ;
        }else if(_type==2){
            [self bindPhone] ;
        }
    }
}

-(BOOL) validatePassword{
    if (_password.text.length<7) {
        [Utile showTipAlert:self title:@"提示" message:@"密码长度应大于8位"];
        return NO ;
    }else if (![_password.text isEqualToString:_passwordAgan.text]){
     [Utile showTipAlert:self title:@"提示" message:@"两次密码不一样"];
        return NO ;
    }else{
        return YES;
    }
}
-(void)regist{
    RegistApi* registApi = [[RegistApi alloc] init] ;
    registApi.clientType=2 ;
    registApi.account=_phoneNumber ;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_TOKEN]) {
        registApi.deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:DEVICE_TOKEN] ;
    }
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    registApi.position=[userDefault objectForKey:@"location"];
    registApi.password=_password.text ;
    UIDevice *device =[[UIDevice alloc]init] ;
    registApi.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    [registApi executeHasParse:^(id jsonData) {
        //注册成功之后需要回到首页
        User* user =[User initWithJSON:jsonData] ;
        [[UserDao sharedInstance]insert:user];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        
    }] ;
}

-(void)modifyPass{
    ChangePassApi* api =[[ChangePassApi alloc]init] ;
    api.account=_phoneNumber ;
    api.password=_password.text ;
    [api executeHasParse:^(id jsonData) {
       //修改密码成功后的地方
        User* user =[User initWithJSON:jsonData] ;
        [[UserDao sharedInstance]insert:user];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        
    }];
}

-(void) bindPhone{
    BindPhoneApi* api = [[BindPhoneApi alloc]init] ;
    api.account=_phoneNumber ;
    api.password=_password.text ;
    User* user =[[UserDao sharedInstance]loadUser] ;
    api.userId=user.userId ;
    [api executeHasParse:^(id jsonData) {
        User* user = [User initWithJSON:jsonData] ;
        [[UserDao sharedInstance] insert:user] ;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        
    }] ;
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
