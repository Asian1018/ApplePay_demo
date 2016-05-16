//
//  EditMessageViewController.m
//  colorRun
//
//  Created by engine on 15/11/4.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "EditMessageViewController.h"

@interface EditMessageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIView *contentViewBg;

@end

@implementation EditMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat top = 4; // 顶端盖高度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, top, top, top);
    UIImage *image = [UIImage imageNamed:@"my_input"] ;
    image= [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _bgImage.image=image ;
    _editText.delegate=self ;
    self.navigationItem.title=@"个性签名";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doFinish)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    _editText.text = _user.signature.length < 16 ? _user.signature : [_user.signature substringToIndex:15];
    _textCountLabel.text=[NSString stringWithFormat:@"%lu/15",_editText.text.length] ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void) doFinish{
    if (_editText.text.length>0) {
        Updatesignature* api = [[Updatesignature alloc]init] ;
        api.userId=_user.userId ;
        api.signature=_editText.text ;
        [api executeHasParse:^(id jsonData) {
            /**
             *  0 修改成功
             1 修改失败（敏感字）
             2修改失败(特殊字符)
             */
            NSString * str = [NSString stringWithFormat:@"%@",jsonData[@"status"]];
            if ([str isEqualToString:@"0"]) {
                User* u = [User initWithJSON:jsonData] ;
                [[UserDao sharedInstance]insert:u];
                _user.signature= _editText.text ;
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([str isEqualToString:@"1"]) {
                [Utile showPromptAlertWithString:@"修改失败,个性签名含有敏感词喔~~"];
            
            }
            else if([str isEqualToString:@"2"]) {
                [Utile showPromptAlertWithString:@"修改失败,个性签名不能有特殊字符喔~~"];
                
            }
            
        } failure:^(NSString *error) {
            
        }];
    }
   
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 15) {
        textView.text = [textView.text substringToIndex:15];
        _textCountLabel.text = @"15/15";
        return;
    }
    _textCountLabel.text=[NSString stringWithFormat:@"%lu/15",textView.text.length] ;

}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_editText becomeFirstResponder];
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
