//
//  ResetPasswordViewController.h
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMSSDK.h>
#import "StyleUtile.h"
#import "SurePasswordViewController.h"
@interface ResetPasswordViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *checkCode;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UILabel *nextPotoLable;
@property (weak, nonatomic) IBOutlet UIButton *herePoto;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property(assign,nonatomic) NSInteger type ;
-(void) timeFireMethod:(NSTimer*) timer;
@end
