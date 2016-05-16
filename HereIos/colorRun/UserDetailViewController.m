//
//  UserDetailViewController.m
//  colorRun
//
//  Created by engine on 15/11/4.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "UserDetailViewController.h"
#import "RDVTabBarController.h"
#import "EditMessageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "EditUserNameViewController.h"
#import "CoolApi.h"
#import "UserDao.h"
@interface UserDetailViewController (){
    User * user;
    BOOL changeAvatar ;
    NSString* picPath  ;
}

@end

@implementation UserDetailViewController
- (IBAction)saveAction:(UIButton *)sender {
    UpdateUserApi* update= [[UpdateUserApi alloc]init] ;
    update.userId = user.userId ;
    update.sex = user.sex ;
    if (picPath) {
        [update addFilePath:picPath] ;
    }
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [update excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
        hud.hidden = YES;
        [[UserDao sharedInstance]insert:user];
        NSLog(@"修改成功");
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *response, NSError *error) {
        NSLog(@"保存失败");
        hud.hidden = YES;
        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:error.description delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [al show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.otherInfoType isEqualToString:@"1"]) {
        self.saveBtn.hidden = YES;
    }
    changeAvatar=NO ;
    self.saveBtn.backgroundColor = [Utile green];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"我的信息";
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor] ;
//    self.navigationController.navigationItem.leftBarButtonItem.title=@"" ;
    self.tableView.delegate=self ;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2 ;
    self.avatar.clipsToBounds = YES;
    user = [[UserDao sharedInstance] loadUser];
    [self fillUI] ;
}
-(void) fillUI{
    if (self.model) {
        user.avatar = self.model.avatar;
        user.sex =self.model.sex;
        user.createTime = self.model.createTime;
        user.signature = self.model.signature;
        user.position = self.model.position;
        user.oauthType = self.model.oauthType;
        user.nickName = self.model.nickName;
    }
    [self fillUIWithUser] ;
   
}

-(void) fillUIWithUser{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"my_voucher"]];
    _nikeName.text=user.nickName ;
    //1 : wb 2 : qq 3 : wx
    if (user.oauthType==1 ) {
        UIImage* image = [UIImage imageNamed:@"my_sina"] ;
        _oautType.image=image ;
    }else if (user.oauthType ==2){
        UIImage* image = [UIImage imageNamed:@"my_qq"] ;
        _oautType.image=image ;
    }
    else if (user.oauthType ==2){
        UIImage* image = [UIImage imageNamed:@"my_wechat"] ;
        _oautType.image=image ;
    }
    else{
        UIImage* image = [UIImage imageNamed:@"my_phone"] ;
        _oautType.image=image ;
    }
    if (user.sex==1) {
        _gender.text=@"男" ;
    }else if (user.sex==2){
        _gender.text=@"女" ;
        self.sexImageView.image = [UIImage imageNamed:@"my_woman"];
    }
    else{
        _gender.text = @"未知性别";
        self.sexImageView.hidden = YES;
    }
    _createTime.text=user.createTime ;
    _signature.text=user.signature ;
    _position.text = user.position ;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES] ;
    _signature.text=user.signature ;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.`1
}
//需要调试
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.model) {
        if (indexPath.row==6) {
            UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            EditMessageViewController *editMessage=[borad instantiateViewControllerWithIdentifier:@"editMessageController"] ;
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            editMessage.user = user ;
            //  [[[UserDao alloc]init]insert:_user];
            [self.navigationController pushViewController:editMessage animated:YES] ;
        }else if (indexPath.row==2){
            UIStoryboard *borad = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
            EditUserNameViewController *editName=[borad instantiateViewControllerWithIdentifier:@"editNameController"] ;
            editName.delegate=self ;
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            editName.user=user ;
            [self.navigationController pushViewController:editName animated:YES] ;
        }else if (indexPath.row==1){
            [self changeAvatar] ;
        }else if (indexPath.row==3){
            [self changeSex] ;
        }
    }
}
-(void) editFinish:(NSString *)userName{
    user.nickName=userName ;
    [self fillUIWithUser] ;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    NSLog(@"----pick") ;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
 NSLog(@"----pick---") ;
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    NSData * imageData = UIImageJPEGRepresentation(image,0.01);
    NSInteger length = [imageData length]/1024;
    NSLog(@"图片大小:%ld",(long)length);
    _avatar.image=image ;
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* avatarPath = [documentPath stringByAppendingPathComponent:@"avatar"];
    
    //图片数据保存到 document
    [imageData writeToFile:avatarPath atomically:YES];
    changeAvatar=YES ;
   picPath=[documentPath stringByAppendingPathComponent:@"avatar"];

    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"cancel") ;
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) changeAvatar{
    UIAlertController *aler=[UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //从相机选取
    UIAlertAction *album=[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing=YES;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    //拍照
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing=YES;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancl=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aler addAction:cancl];
    [aler addAction:album];
    [aler addAction:camera];
    [self presentViewController:aler animated:YES completion:nil];
}

-(void) changeSex{
 UIAlertController *aler=[UIAlertController alertControllerWithTitle:@"性别选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *male=[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"sex=男");
        user.sex=1 ;
        [self fillUIWithUser] ;
    }];
    UIAlertAction *female=[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       user.sex=2 ;
        [self fillUIWithUser] ;
    }];
    UIAlertAction *cancl=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [aler addAction:cancl];
    [aler addAction:male];
    [aler addAction:female];
    [self presentViewController:aler animated:YES completion:nil];

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
