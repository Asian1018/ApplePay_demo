//
//  EditUserNameViewController.m
//  colorRun
//
//  Created by engine on 16/1/27.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "EditUserNameViewController.h"

@interface EditUserNameViewController ()<UITextFieldDelegate>

@end

@implementation EditUserNameViewController

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
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"设置昵称" ;
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 8, _userNameText.frame.size.height)];
    leftView.backgroundColor=[UIColor whiteColor] ;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doFinish)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.userNameText.leftViewMode=UITextFieldViewModeAlways ;
    self.userNameText.leftView=leftView ;
    _userNameText.text=_user.nickName ;
    _userNameText.delegate = self;
    [_userNameText becomeFirstResponder] ;
}
-(void) doFinish{
    if (_userNameText.text.length>0) {
        UpdateNickNameApi* api = [[UpdateNickNameApi alloc]init] ;
        api.userId=_user.userId ;
        api.nickname=_userNameText.text ;
        _user.nickName= _userNameText.text ;
        [api executeHasParse:^(id jsonData) {
            User* u=[User initWithJSON:jsonData] ;
            [[UserDao sharedInstance]insert:u];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate editFinish:_userNameText.text];
        } failure:^(NSString *error) {
            
        }];
    }
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
