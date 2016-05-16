
#import "TakeCardViewController.h"
#import "SJAvatarBrowser.h"
#import "PicButton.h"
#import <CoreLocation/CoreLocation.h>
#import "MHImagePickerMutilSelector.h"
@interface TakeCardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PicButtonDelegate,CLLocationManagerDelegate,MHImagePickerMutilSelectorDelegate>{
    NSInteger buttunTag;
    CLLocationManager * locationManager;
    NSString* cityName;
    NSString * Image1stPath;
    NSString * Image2stPath;
    NSString * Image3stPath;
    NSString * Image4stPath;
    NSString* avatarPath1st;
    NSString* avatarPath2st;
    NSString* avatarPath3st;
    NSString* avatarPath4st;
}
@property (weak, nonatomic) IBOutlet PicButton *pic1st;
@property (weak, nonatomic) IBOutlet PicButton *pic2st;
@property (weak, nonatomic) IBOutlet PicButton *pic3st;
@property (weak, nonatomic) IBOutlet PicButton *pic4st;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIImageView *addressPic;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;


@end

@implementation TakeCardViewController
- (void)locate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        locationManager=[[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10;
        [locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (cityName) {
        
        return;
    }
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = @"";
             if (!placemark.locality) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             if (placemark.administrativeArea) {
                 city = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
             }
             cityName = city;
             NSLog(@"定位完成:%@",cityName);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             self.addressLabel.text = city;
             self.takeCardApi.position = city;
             [manager stopUpdatingLocation];
             [locationManager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Image1stPath = @"file0.jpg";
    Image2stPath = @"file1.jpg";
    Image3stPath = @"file2.jpg";
    Image4stPath = @"file3.jpg";
    [self locate];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissView)];
    self.addressSwitch.on = YES;
    self.pic1st.delegate = self;
    self.pic2st.delegate = self;
    self.pic3st.delegate = self;
    self.pic4st.delegate = self;
//    self.titleLabel.text = self.takeCardApi.title;
    self.titleLabel.text = [NSString stringWithFormat:@"在Here，%@",self.takeCardApi.title];
    self.takeCardApi.position = self.addressLabel.text;
    self.takeCardApi.isPosition = 0;
    self.completeButton.enabled = NO;
    [self weatherCompleteButtonClicked];
    
}
-(void)weatherCompleteButtonClicked{
    //0:快捷1:图片2:计步3:跑步
    if (self.cardType != 1) {
        self.completeButton.enabled = YES;
        [self.completeButton setBackgroundColor:[Utile green]];
    }

}
-(void)deletePicAction:(UIButton *)button{
    NSLog(@"删除了第%ld的数据",(long)button.tag);
    if (self.cardType == 1) {
        if (!self.pic1st.currentImage & !self.pic2st.currentImage & !self.pic3st.currentImage & !self.pic4st.currentImage) {
            self.completeButton.enabled = NO;
            [self.completeButton setBackgroundColor:[UIColor lightGrayColor]];
        }
        
    }
}
-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
- (IBAction)showAddress:(UISwitch *)sender {
    //默认是显示
    if (sender.isOn) {
        self.addressLabel.hidden = NO;
        self.addressPic.hidden = NO;
        self.takeCardApi.position = self.addressLabel.text;
        self.takeCardApi.isPosition = 0;
    }
    else{
        self.addressLabel.hidden = YES;
        self.addressPic.hidden = YES;
        self.takeCardApi.position = nil;
        self.takeCardApi.isPosition = 1;
    }
}
-(void)imagePickerMutilSelectorDidGetImages:(NSArray *)imageArray
{
    NSMutableArray*  importItems=[[NSMutableArray alloc] initWithArray:imageArray copyItems:YES];
    NSLog(@"result--%@",importItems);
}
-(void)chooseImage{
    UIAlertController *aler=[UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //从相机选取
    UIAlertAction *album=[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
//        picker.showsCameraControls = YES;
        picker.allowsEditing = YES;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    //从相机拍摄
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

- (IBAction)choosePictureClicked:(UIButton*)sender {
    buttunTag = sender.tag;
    [self chooseImage];
}
- (IBAction)completeButtonClicked:(id)sender {
    NSLog(@"点击完成");
    if (self.pic1st.currentImage) {
        if (avatarPath1st.length > 0) {
            [self.takeCardApi addFilePath:avatarPath1st];
            NSLog(@"有图片1");
        }
    }
    if (self.pic2st.currentImage) {
        if (avatarPath2st.length > 0) {
            [self.takeCardApi addFilePath:avatarPath2st];
             NSLog(@"有图片2");
        }
    }

    if (self.pic3st.currentImage) {
        if (avatarPath3st.length > 0) {
            [self.takeCardApi addFilePath:avatarPath3st];
              NSLog(@"有图片3");
        }
    }

    if (self.pic4st.currentImage) {
        if (avatarPath4st.length > 0) {
            [self.takeCardApi addFilePath:avatarPath4st];
            NSLog(@"有图片4");
        }
    }
    MBProgressHUD * hud = [Utile showHudInView:self.view];
   [_takeCardApi executeHasParse:^(id jsonData) {
       hud.hidden = YES;
       if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"]) {
           //成功
            NSLog(@"成功");
           [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:TAKECARD_SUCCESS object:nil];
               
           }];
       }
       else{
           NSLog(@"失败");
       }
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    NSData * imageData = UIImageJPEGRepresentation(image,0.2);
    NSInteger length = [imageData length]/1024;
    NSLog(@"图片大小:%ld",(long)length);
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
    self.completeButton.enabled = YES;
    [self.completeButton setBackgroundColor:[Utile green]];
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    switch (buttunTag) {
        case 1:{
            [self.pic1st setImage:image forState:UIControlStateNormal];
            [self.pic1st drawCancleButton];
            avatarPath1st = [documentPath stringByAppendingPathComponent:Image1stPath];
            //图片数据保存到 document
            [imageData writeToFile:avatarPath1st atomically:YES];
            
        }
            break;
        case 2:{
            [self.pic2st setImage:image forState:UIControlStateNormal];
            [self.pic2st drawCancleButton];
            avatarPath2st = [documentPath stringByAppendingPathComponent:Image2stPath];
            //图片数据保存到 document
            [imageData writeToFile:avatarPath2st atomically:YES];
        }
            break;
        case 3:{
            [self.pic3st setImage:image forState:UIControlStateNormal];
            [self.pic3st drawCancleButton];
            
            avatarPath3st = [documentPath stringByAppendingPathComponent:Image3stPath];
            //图片数据保存到 document
            [imageData writeToFile:avatarPath3st atomically:YES];
        }
            break;
        case 4:{
            [self.pic4st setImage:image forState:UIControlStateNormal];
            [self.pic4st drawCancleButton];
            avatarPath4st = [documentPath stringByAppendingPathComponent:Image4stPath];
            //图片数据保存到 document
            [imageData writeToFile:avatarPath4st atomically:YES];
        }
            break;
        default:
            break;
    }
}

@end
