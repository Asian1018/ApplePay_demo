//
//  SurePasswordViewController.h
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleUtile.h"
@interface SurePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgan;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(assign,nonatomic) NSInteger type ;//0注册 1 忘记密码 2：绑定密码
@property(nonatomic,strong) NSString* phoneNumber ;
@end
