
#import "SignAddressViewController.h"

@interface SignAddressViewController ()<UITextViewDelegate,UITextFieldDelegate>{

}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *intenetLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *playHolderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *errorImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *handUpButton;

@end

@implementation SignAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.textColor = [Utile orange];
    self.statusLabel.textColor = [Utile green];
    self.title = @"填写领奖信息";
    self.addressTextView.delegate = self;
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    [self.nameTextField becomeFirstResponder];
    self.resultLabel.hidden = YES;
    self.intenetLabel.hidden = YES;
    self.errorImageView.hidden = YES;
    self.statusLabel.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)handUpButtonClicked:(UIButton *)sender {
    [self.view resignFirstResponder];
    if(self.nameTextField.text.length  > 0 && self.phoneTextField.text.length > 0 && self.addressTextView.text.length > 0){
        [self handup];
        return;
    }
}
-(void)handup{
    if (self.nameTextField.text.length  == 0 || self.phoneTextField.text.length == 0 || self.addressTextView.text.length == 0) {
        [Utile showPromptAlertWithString:@"请填写完整的信息"];
    }
    else{
        //网络提交
        SaveReward * save = [[SaveReward alloc]init];
        save.userId = [[UserDao sharedInstance]loadUser].userId ;
        save.rewardId = [self.model.rewardId integerValue];
        save.userName = self.nameTextField.text;
        save.phone = self.phoneTextField.text;
        save.address = self.addressTextView.text;
        self.statusLabel.hidden = NO;
        self.errorImageView.hidden = YES;
        self.intenetLabel.hidden = YES;
        self.intenetLabel.text = @"哎呀~网络出问题了";
        [save excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
            
            if ([responseDate[@"code"] isEqualToString:@"0"]) {
                NSDictionary * dic = responseDate[@"data"];
                if (dic[@"status"] ==0) {
                    NSLog(@"领取成功");
                    [Utile showWZHUDWithView:self.navigationController.view andString:@"领取成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    [Utile showPromptAlertWithString:@"领取失败"];
                    self.errorImageView.hidden = NO;
                    self.intenetLabel.hidden = NO;
                    self.intenetLabel.text = @"领取失败";
                    self.statusLabel.hidden = YES;
                }
            }
            else{
//                NSString * str = @"网络请求失败";
//                [Utile showPromptAlertWithString:str];
                self.statusLabel.hidden = YES;
                self.errorImageView.hidden = NO;
                self.intenetLabel.hidden = NO;
            }
            
        } failure:^(NSURLSessionDataTask *response, NSError *error) {
            self.errorImageView.hidden = NO;
            self.intenetLabel.hidden = NO;
            self.statusLabel.hidden = YES;
        }];
        
    }
}
-(void)showButtonState{
    if (self.nameTextField.text.length  > 0 && self.phoneTextField.text.length > 0 && self.addressTextView.text.length > 0) {
        [self.handUpButton setBackgroundImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
    }
    else{
        [self.handUpButton setBackgroundImage:[UIImage imageNamed:@"reward_prize"] forState:UIControlStateNormal];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    [self showButtonState];
    if ([textView.text isEqualToString:@""]) {
        self.playHolderLabel.hidden = NO;
    }
    else{
        self.playHolderLabel.hidden = YES;
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
        [self showButtonState];
    if (textField == self.phoneTextField) {
        if (textField.text.length >= 11) {
            self.phoneTextField.text = [textField.text substringToIndex:10];
        }
    }

    return YES;
}

- (IBAction)deleteName:(id)sender {
    self.nameTextField.text = @"";
}
- (IBAction)deletePhone:(id)sender {
    self.phoneTextField.text = @"";
}
- (IBAction)deleteAddress:(id)sender {
    self.addressTextView.text = @"";
    self.playHolderLabel.hidden = NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTextField) {
        [self.phoneTextField becomeFirstResponder];
        return YES;
    }
    [self.phoneTextField resignFirstResponder];
    [self.addressTextView becomeFirstResponder];
    return YES;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.addressTextView resignFirstResponder];
//        [self handup];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
