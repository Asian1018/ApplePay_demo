//
//  CreatCardThirdViewController.m
//  colorRun
//
//  Created by zhidian on 16/1/13.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "CreatCardThirdViewController.h"
#import "CreatCardSuccessViewController.h"
#import "StepChooseViewController.h"
@interface CreatCardThirdViewController ()<UITextViewDelegate,StepChooseViewControllerDelegate,UITextFieldDelegate>{

}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTargetLabel;
@property (weak, nonatomic) IBOutlet UIButton *notiButton;
@property (weak, nonatomic) IBOutlet UIButton *notNotiButton;
@property (weak, nonatomic) IBOutlet UITextView *cardContendTextView;
@property (weak, nonatomic) IBOutlet UILabel *playHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCountLabel;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property(strong , nonatomic) UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *cardDesCell;

@end
@implementation CreatCardThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cardApi.broadcast = 2;
    self.nameTextField.delegate = self;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.cardApi.targetValue = 0;
    self.completeButton.enabled = NO;
    self.sportTypeLabel.layer.cornerRadius = 10;
    self.cardContendTextView.delegate = self;
    self.sportTypeLabel.clipsToBounds = YES;
    UILabel * la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.footerView.frame.size.width, 0.5)];
    la.backgroundColor = [UIColor lightGrayColor];
    [self.footerView addSubview:la];
    [self.notiButton setImage:[UIImage imageNamed:@"choice_press"] forState:UIControlStateSelected];
    [self.notNotiButton setImage:[UIImage imageNamed:@"choice_press"] forState:UIControlStateSelected];
    [self.nameTextField addTarget:self action:@selector(changeName:) forControlEvents:UIControlEventEditingChanged];
    //0:快捷1:图片2:计步3:跑步
    switch (self.cardApi.cardType) {
        case 0:{
            self.sportTypeLabel.text = @"快捷";
            self.sportDescLabel.text = @"打卡时不要求上传图片";
        }
            break;
        case 1:{
            self.sportTypeLabel.text = @"图片";
            self.sportDescLabel.text = @"打卡时要求上传图片";
            
        }
            break;
        case 2:{
            self.sportTypeLabel.text = @"计步";
            self.sportDescLabel.text = @"打卡时要使用计步工具或功能";
            
        }
            break;
        case 3:{
            self.sportTypeLabel.text = @"跑步";
            self.sportDescLabel.text = @"打卡时要使用跑步工具或功能";
            
        }
            break;
            
        default:
            break;
    }
    if (self.cardApi.cardMode == 1) {
        self.cardTypeLabel.text = @"生活也要玩";
    }
}

#pragma UITextFieldDelegate
-(void)changeName:(UITextField*)textField{
    self.cardApi.title = self.nameTextField.text;
    [self weatherShouldCreatCard];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTextField resignFirstResponder];
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.tableView.frame.size.width < 330) {
        self.notiButton.titleLabel.font = PHONE_320_FONT;
        self.notNotiButton.titleLabel.font = PHONE_320_FONT;
        [self setStringFont];
    }
    CGFloat heigth = [UIScreen mainScreen].applicationFrame.size.height - CGRectGetMaxY(self.cardDesCell.frame) - 44;
    CGRect frame = self.footerView.frame;
    frame.size.height = heigth;
    self.footerView.frame = frame;
//    self.footerView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableFooterView = self.footerView;
}
- (IBAction)completeButtonClicked:(id)sender {
//    NSRange range = [self.nameTextField.text rangeOfString:@")\">\n"];//判断字符串是否包含
//    
//   if (range.location !=NSNotFound)//不包含
////    if (range.length >0)//包含
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"卡片名称请不要输入特殊符号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//        return;
//    }
    
    if ([self stringContainsEmoji:self.nameTextField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"卡片名称请不要输入表情符号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
//    Sensitive * sen = [[Sensitive alloc]init];
//    sen.content = self.nameTextField.text;
//    //0 符合约束  1 敏感字符  2 特殊字符
//    [sen executeHasParse:^(id jsonData) {
//        NSString * status = [NSString stringWithFormat:@"%@",jsonData[@"status"]];
//        if ([status isEqualToString:@"0"]) {
            self.completeButton.enabled = NO;
            if (_cardContendTextView.text.length > 0) {
                self.cardApi.bewrite = _cardContendTextView.text;
            }
            [_cardApi executeHasParse:^(id jsonData) {
                hud.hidden = YES;
                self.completeButton.enabled = YES;
                NSLog(@"结果:%@",jsonData);
                if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
                    //成功
                    
                    CreadCardModel * model = [CreadCardModel initWithJSON:jsonData];
                    self.model = model;
                    [self.tableView reloadData];
                    [self performSegueWithIdentifier:@"successCreat" sender:nil];
                }
                else{
                    [Utile showWZHUDWithView:self.navigationController.view andString:@"操作不成功,请修改或稍后再试试~~"];
                
                }
                
            } failure:^(NSString *error) {
                hud.hidden = YES;
                self.completeButton.enabled = YES;
                [Utile showPromptAlertWithString:error];
            }];
 
//        }
//        else if ([status isEqualToString:@"1"]) {
//            hud.hidden = YES;
//            [Utile showPromptAlertWithString:@"卡片名称不能含有敏感字符喔~~"];
//        }
//        else if ([status isEqualToString:@"2"]) {
//            hud.hidden = YES;
//            [Utile showPromptAlertWithString:@"卡片名称不能含有特殊字符喔~~"];
//        }
//        
//    } failure:^(NSString *error) {
//        hud.hidden = YES;
//        [Utile showPromptAlertWithString:error];
//    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 50;
    }
    if (indexPath.row == 4) {
        return 60;
    }
    if (indexPath.row == 5) {
        return 110;
    }
    if (indexPath.row == 3) {
        if (self.cardApi.cardType == 2 || self.cardApi.cardType == 3) {
            return 44;
        }
        return 0.1;
    }
    return 44;
}
- (IBAction)notiButtonClicked:(UIButton *)sender {
    if(sender != self.selectedButton) {
        self.selectedButton.selected = NO;
        self.selectedButton = sender;
        NSLog(@"选择类型:%ld",(long)sender.tag);
    }
    self.selectedButton.selected=YES;
    self.cardApi.broadcast = sender.tag;
    [self weatherShouldCreatCard];
     NSString * firstString = @"noti_firstTime";//广播
     NSString * SecString = @"noti_SecString";
    if (sender.tag == 0) {
        //广播
        if ([[NSUserDefaults standardUserDefaults]valueForKey:firstString]) {
            //已经提示过了
            return;
        }
        else{
            [Utile showPromptAlertWithString:@"卡片有机会获得Here社区推荐"];
            [[NSUserDefaults standardUserDefaults]setValue:@"22" forKey:firstString];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
        }

    }
    else{
        if ([[NSUserDefaults standardUserDefaults]valueForKey:SecString]) {
            //已经提示过了
            return;
        }
        else{
            [Utile showPromptAlertWithString:@"可以邀请朋友一起无干扰地奋战"];
            [[NSUserDefaults standardUserDefaults]setValue:@"22" forKey:SecString];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.playHolderLabel.hidden = NO;
    }
    else{
        self.playHolderLabel.hidden = YES;
    }
    if (textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
        self.numberCountLabel.text = @"50/50";
        return;
    }
    _numberCountLabel.text=[NSString stringWithFormat:@"%lu/50",textView.text.length] ;
}

-(void)setStringFont{
    NSString * Bstr = @"广播 全社区用户都会找到这卡片";
    NSString * notiStr = @"不广播 安静地玩耍,也可邀请朋友";
    NSMutableAttributedString* changeText = [[NSMutableAttributedString alloc]initWithString:Bstr];
    NSMutableAttributedString* notichangeText = [[NSMutableAttributedString alloc]initWithString:notiStr];
    [changeText addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:11]
                       range:NSMakeRange(2, Bstr.length - 2)] ;
    [notichangeText addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:11]
                           range:NSMakeRange(2, Bstr.length - 2)] ;
    [changeText addAttribute:NSForegroundColorAttributeName
                       value:[UIColor lightGrayColor]
                       range:NSMakeRange(0, Bstr.length)];
    [notichangeText addAttribute:NSForegroundColorAttributeName
                           value:[UIColor lightGrayColor]
                           range:NSMakeRange(0, notiStr.length)];

    [self.notiButton setAttributedTitle:changeText forState:UIControlStateNormal];
    [self.notNotiButton setAttributedTitle:notichangeText forState:UIControlStateNormal];
    
}
- (IBAction)cancleButtonClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        //选择步数
        StepChooseViewController * step = [[StepChooseViewController alloc]init];
        step.delegate = self;
        step.sportType = self.cardApi.cardType;
        
        [self.navigationController pushViewController:step animated:YES];
        
        
    }

}
-(void)weatherShouldCreatCard{
    BOOL succ = YES;
    if (!self.cardApi.title || self.cardApi.title.length == 0) {
        succ = NO;
    }
    if (self.cardApi.cardType == 2 || self.cardApi.cardType == 3) {
        if (self.cardApi.targetValue == 0) {
            succ = NO;
        }
    }
    if (self.cardApi.broadcast > 1) {
        succ = NO;
    }
    if (succ) {
        self.completeButton.enabled = YES;
        [self.completeButton setBackgroundColor:[Utile green]];
    }
    
}
#pragma StepChooseViewControllerDelegate
-(void)getResultStepWithCount:(NSString *)count{
    if (self.cardApi.cardType == 3) {
        //跑步
        self.cardTargetLabel.text = [NSString stringWithFormat:@"目标里程 %@km",count];
        
        self.cardApi.targetValue =[[NSString stringWithFormat:@"%f", [count floatValue] * 1000] integerValue];
    }
    else{
        self.cardTargetLabel.text = [NSString stringWithFormat:@"目标步数 %@",count];
        self.cardApi.targetValue = [count integerValue];
    }
    [self weatherShouldCreatCard];
}

#pragma UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self.cardContendTextView resignFirstResponder];
        //        [self handup];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"successCreat"]) {
        CreatCardSuccessViewController * success = segue.destinationViewController;
        success.model = self.model;
        success.cardType = self.cardApi.cardType;
    }
    
}

//successCreat

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nameTextField) {
        if (textField.text.length > 30) {
            textField.text = [textField.text substringToIndex:30];
        }
        //||[self stringContainsEmoji:string]
//        if ([self stringContainsEmoji:self.nameTextField.text]) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Nice try" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            return NO;
//        }
    }
    return YES;
}


- (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

@end
