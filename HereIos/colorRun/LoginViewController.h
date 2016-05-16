//
//  LoginViewController.h
//  colorRun
//
//  Created by engine on 15/11/5.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseViewController.h"
#import "PhoneLoginViewController.h"
@class LoginViewController;
@protocol LoginDelegate <NSObject>

-(void)refreshViewInfo;

@end
@interface LoginViewController : BaseViewController<NSCoding>{

   
}
@property(weak, nonatomic)id<LoginDelegate>delegate;
@end
