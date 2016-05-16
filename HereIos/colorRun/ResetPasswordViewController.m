//
//  ResetPasswordViewController.m
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController (){
    NSTimer* timer ;
    NSInteger times  ;
}

@end

@implementation ResetPasswordViewController
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
    times=60 ;
    // Do any additional setup after loading the view.

    _phoneNumber.keyboardType=UIKeyboardTypeNumberPad ;
    _phoneNumber.delegate=self ;
    _checkCode.keyboardType=UIKeyboardTypeNumberPad ;
    _checkCode.delegate = self;
    [StyleUtile initBoundText:_checkCode password:NO needClean:NO] ;
    [StyleUtile initBoundText:_phoneNumber password:NO needClean:YES] ;
    if (_type==1) {//忘记密码
        _nextPotoLable.hidden=YES ;
        _herePoto.hidden=YES ;
        self.navigationItem.title=@"忘记密码";
        self.navigationItem.backBarButtonItem.title=@"" ;
    }else if(_type==2){
        self.navigationItem.title=@"绑定账号";
        self.navigationItem.backBarButtonItem.title=@"" ;
    }else{
        self.navigationItem.title=@"注册";
        self.navigationItem.backBarButtonItem.title=@"" ;
    }
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = barButtonItem;

}
-(void) cancel{
    if (_type==2) {
        
        return ;
    }
    UserbehaviorApi* api = [[UserbehaviorApi alloc]init] ;
    if (_type==0) {
        api.type=0 ;
    }else{
        api.type=1 ;
    }
    api.behavior=1 ;
    UIDevice *device =[[UIDevice alloc]init] ;
    api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;

    [api executeHasParse:^(id jsonData) {
        
    } failure:^(NSString *error) {
        
    }] ;
    if (_type==2) {
        [self dismissViewControllerAnimated:YES completion:nil] ;
    }else{
        [self.navigationController popViewControllerAnimated:YES] ;}
}
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    return YES ;
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
- (IBAction)next:(UIButton *)sender {
    ValidataPhoneApi* api = [[ValidataPhoneApi alloc]init] ;
    if ([self validatePhone:[self phoneNumToNormalNum]]) {
        api.phone=[self phoneNumToNormalNum] ;
        api.clientType=2 ;
        api.securityCode=_checkCode.text ;
        api.type=_type ;
        NSLog(@"phone=%@",[self phoneNumToNormalNum]) ;
        [api executeHasParse:^(id jsonData) {
            [self startSurePassword] ;
        } failure:^(NSString *error) {
            [Utile showPromptAlertWithString:error];
        }];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_type==2) {
        User* user = [[UserDao sharedInstance]loadUser];
        if (user.phone!=nil&&user.phone.length>0) {
            [self dismissViewControllerAnimated:YES completion:nil] ;
        }
    }
}

-(void) startSurePassword{
    NSString* sureControllerIdentify=@"surePassController" ;
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
     SurePasswordViewController *sureController=[borad instantiateViewControllerWithIdentifier:sureControllerIdentify] ;
    sureController.type=_type ;
    sureController.phoneNumber=[self phoneNumToNormalNum] ;
    [self.navigationController pushViewController:sureController animated:YES];
}

-(BOOL) validatePhone:(NSString*) phone{
    if (phone.length!=11) {
        return NO ;
    }
    return YES ;
}



- (IBAction)checkCoder:(UIButton *)sender {
    if (times==60) {
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneNumber.text
                                       zone:@"86"
                           customIdentifier:nil
                                     result:^(NSError *error){
                                         if (!error) {
                                             NSLog(@"获取验证码成功");
                                         } else {
                                             NSLog(@"错误信息：%@",error);
                                         }}];
        if (timer==nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES] ;
        }else if(!timer.isValid){
            [timer fire] ;
        }
 
    }
    
}

-(NSString *)phoneNumToNormalNum
{
    return [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void) timeFireMethod:(NSTimer*) timer{
    times=times-1 ;
    NSLog(@"time=%lu",times);
    if (times>0) {
        _codeButton.backgroundColor=[UIColor grayColor] ;
        _codeButton.enabled=NO ;
        _codeButton.titleLabel.text=[NSString stringWithFormat:@"%lu秒后可重发",times] ;
    }else{
        _codeButton.backgroundColor=[StyleUtile greenColor] ;
        _codeButton.enabled=YES ;
        _codeButton.titleLabel.text=@"获取验证码" ;
        times=60 ;
     [timer invalidate] ;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneNumber) {
        NSString *text = [self.phoneNumber text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        NSString* lastString=@"" ;
        if (text.length>3) {
            newString=[text substringToIndex:3] ;
            newString = [newString stringByAppendingString:@" "];
            lastString=[text substringFromIndex:3] ;
        }else{
            newString=text ;
        }
        while (lastString.length > 0) {
            NSString *subString = [lastString substringToIndex:MIN(lastString.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            lastString = [lastString substringFromIndex:MIN(lastString.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        // 限制长度
        if (newString.length >= 14) {
            return NO;
        }
        
        [self.phoneNumber setText:newString];
        
        return NO;
        
    }
    return YES;
}

@end
