//
//  PhoneLoginViewController.m
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "PhoneLoginViewController.h"

@interface PhoneLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIView *loginHere;

@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [StyleUtile initBoundText:_phoneNumber password:NO needClean:YES] ;
   
    [StyleUtile initBoundText:_password password:YES needClean:YES] ;
    _phoneNumber.delegate=self ;
    _password.delegate = self;
    self.navigationController.title=@"登录";
    
}
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
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forgetPassword:(UIButton *)sender {
//    NSString* forgetPass=@"checkCodeController" ;
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    ResetPasswordViewController *resetPassword=[borad instantiateViewControllerWithIdentifier:@"checkCodeController"] ;
    resetPassword.type=1 ;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:resetPassword animated:YES];
}

/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"getpassword"]) {
        ResetPasswordViewController* resetPass = segue.destinationViewController ;
        resetPass.type=1 ;
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        NSLog(@"segue to ResetPassword");
    }

}*/
- (IBAction)loginInHere:(id)sender {
    PhoneLoginApi* api = [[PhoneLoginApi alloc]init] ;
//    NSString* phoneNumber = _phoneNumber.text ;
    if ([self validatePhone:[self phoneNumToNormalNum]]) {
        api.account=[self phoneNumToNormalNum] ;
        api.password=_password.text ;
        [api executeHasParse:^(id jsonData) {
            //0 登录成功 1 登录失败 2 账号保护状态（5次尝试密码机会）
            NSString *status =[NSString stringWithFormat:@"%@",jsonData[@"status"]];
            if ([status isEqualToString:@"0"]) {
                User* user = [User initWithJSON:jsonData] ;
                UserDao* dao = [UserDao sharedInstance] ;
                [dao insert:user] ;
                [Utile showWZHUDWithView:self.navigationController.view andString:@"登录成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES] ;
            }
            else if ([status isEqualToString:@"1"]){
                [Utile showPromptAlertWithString:@"登录失败,请检查您的账号和密码"];
            
            }
            else if ([status isEqualToString:@"2"]){
                [Utile showPromptAlertWithString:@"账号登录错误超过五次,账号进入保护状态.请明天再尝试~~"];
            }
        
        } failure:^(NSString *error) {
            [Utile showPromptAlertWithString:error];
        }];
    }
   }
- (IBAction)retPassWord:(UIButton *)sender {
}

-(BOOL) validatePhone:(NSString*) phone{
    if (phone.length!=11) {
        return NO ;
    }
    return YES ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
-(NSString *)phoneNumToNormalNum
{
    return [self.phoneNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
