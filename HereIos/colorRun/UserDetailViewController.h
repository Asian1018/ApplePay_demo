//
//  UserDetailViewController.h
//  colorRun
//
//  Created by engine on 15/11/4.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseViewController.h"
#import "UserDao.h"
#import "EditUserNameViewController.h"
@interface UserDetailViewController : UITableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditNameDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *oautType;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nikeName;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *signature;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) NSString * otherInfoType; //1为其他人信息
@property(nonatomic, strong) OtherPersonModel * model;
//@property (nonatomic,strong) User* user ;
@end
