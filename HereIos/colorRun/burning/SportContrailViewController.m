
#import "SportContrailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
//#import "WeiboSDK.h"
#import "BaseMapView.h"
#import "AnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"
#import "ShowResultViewController.h"
#import "AFNetworking.h"
#import "TakeCardViewController.h"
@interface SportContrailViewController ()<MAMapViewDelegate,UMSocialUIDelegate>{
    NSMutableArray * annotationArray;
    MAPointAnnotation *pointAnnotation2;
    
}
@property (weak, nonatomic) IBOutlet RoundView *informationView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet BaseMapView *myMapView;
@property (strong, nonatomic)NSString * showStr;
@property (nonatomic, strong) AnimatedAnnotation *animatedStart;
@property (nonatomic, strong) AnimatedAnnotation *animatedEnd;
@end

@implementation SportContrailViewController

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _myMapView = nil;
    [_myMapView removeFromSuperview];
    
}
-(void)addStartAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray *trainImages = [[NSMutableArray alloc] init];
    [trainImages addObject:[UIImage imageNamed:@"destination"]];
    
    self.animatedStart = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    self.animatedStart.animatedImages = trainImages;
    self.animatedStart.title          = @"起点";
    //    self.animatedStart.subtitle       = [NSString stringWithFormat:@"Train: %lu images",(unsigned long)[self.animatedTrainAnnotation.animatedImages count]];
    
    [self.myMapView addAnnotation:self.animatedStart];
    [self.myMapView selectAnnotation:self.animatedStart animated:YES];
}
-(void)addEndAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate String:(NSString*)string
{
    NSMutableArray *trainImages = [[NSMutableArray alloc] init];
    [trainImages addObject:[UIImage imageNamed:@"origin"]];
    
    self.animatedEnd = [[AnimatedAnnotation alloc] initWithCoordinate:coordinate];
    self.animatedEnd.animatedImages = trainImages;
    self.animatedEnd.title          = string;
    //    self.animatedStart.subtitle       = [NSString stringWithFormat:@"Train: %lu images",(unsigned long)[self.animatedTrainAnnotation.animatedImages count]];
    
    [self.myMapView addAnnotation:self.animatedEnd];
    [self.myMapView selectAnnotation:self.animatedEnd animated:YES];
}

-(void)showRewardViewInSportMatch{
    //    self.activityDetail.meter = 15;
    //没有奖励的活动直接pass,不显示
    if (self.activityDetail) {
        if (_activityDetail.isReward == 1) {
            return;
        }
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ShowResultViewController *result =[borad instantiateViewControllerWithIdentifier:@"showResultViewController"] ;
        result.rewardType = self.rewardType;
        result.rewardBewrite = self.rewardBewrite;
        result.status=self.status ;
        result.date=self.date ;
        [self.navigationController presentViewController:result animated:YES completion:^{
            [result fillContabceForResultView:self.activityDetail BurningModel:self.burnModel];
        }] ;
    }
}
-(void)jumpTakeView{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"TakeCard" bundle:[NSBundle mainBundle]];
    TakeCardViewController *takeCard =[borad instantiateViewControllerWithIdentifier:NSStringFromClass([TakeCardViewController class])] ;
    CardShareData * data = [[CardShareData alloc]init];
    data.qcId = self.models.qcId;
    data.userId = [[UserDao sharedInstance]loadUser].userId;
    data.cardId = self.models.cardId;
    data.title = [NSString stringWithFormat:@"坚持#%@#%ld天",self.models.title,(long)self.models.userDays + 1];
    data.target = self.models.target;
    data.targetValue = self.models.targetValue;
    takeCard.takeCardApi = data;
    takeCard.cardType = self.models.cardType;
    takeCard.userDays = self.models.userDays;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:takeCard];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled] && ![WeiboSDK isWeiboAppInstalled]) {
//    //所有第三方APP都没有装
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
//    }
    if (self.cardMeter <= self.burnModel.totalMeter) {
        [Utile showWZHUDWithView:self.navigationController.view andString:@"跑步目标达成~"];
        [self jumpTakeView];
    }
    else{
        [Utile showWZHUDWithView:self.navigationController.view andString:@"跑步打卡失败~再做努力喔!"];
    }
    [self showRewardViewInSportMatch];
    annotationArray = [NSMutableArray array];
    self.timeView.layer.cornerRadius = 12;
    self.timeView.clipsToBounds = YES;
    self.myMapView.showsCompass = NO;
    self.myMapView.showsScale = NO;
    self.myMapView.showsUserLocation = YES;
    self.myMapView.userTrackingMode = MAUserTrackingModeFollow;
    if ([self.fromType isEqualToString:@"0"]) {
        [self.myMapView setZoomLevel:16.1 animated:YES];
    }
    else{
        [self.myMapView setZoomLevel:14.1 animated:YES];
    }
    self.myMapView.delegate = self;
    [self controlLocationInformation];
    
    self.speedPerHourLabel.text = [NSString stringWithFormat:@"%@km/h",self.burnModel.pace];
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@/km",self.burnModel.avgPace];
    self.fastestSpeedLabel.text = [NSString stringWithFormat:@"%@/km",self.burnModel.maxPace];
    self.slowestSpeedLabel.text = [NSString stringWithFormat:@"%@/km",self.burnModel.minPace];
    
    if (self.view.frame.size.width < 330) {
        self.speedPerHourLabel.font = PHONE_320_FONT;
        self.averageSpeedLabel.font = PHONE_320_FONT;
        self.fastestSpeedLabel.font = PHONE_320_FONT;
        self.slowestSpeedLabel.font = PHONE_320_FONT;
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日 HH点mm分"];
    NSString * str = [formatter stringFromDate:self.burnModel.lastDate];
    self.timeLabel.text = str;
    //    [self testControlLocationInformation];
    [self insteadBackIcon];
    
}
-(void)insteadBackIcon{
    UIBarButtonItem * buttons = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_black_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backActions)];
    self.navigationItem.leftBarButtonItem = buttons;
}

-(void)backActions{
    if ([self.fromType isEqualToString:@"0"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


//正式划运动轨迹线
-(void)controlLocationInformation{
    CLLocationCoordinate2D commonPolylineCoords[self.locatArray.count];
    for (int i = 0; i< self.locatArray.count; i++) {
        CLLocation *cl = [self.locatArray objectAtIndex:i];
        commonPolylineCoords[i].latitude = cl.coordinate.latitude;
        commonPolylineCoords[i].longitude = cl.coordinate.longitude;
    }
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:self.locatArray.count];
    //在地图上添加折线对象
    [self.myMapView addOverlay: commonPolyline];
    [self showNormalPointAnnotation];
    
}

//正式添加标注
-(void)showNormalPointAnnotation{
    if (self.locatArray.count > 1) {
        CLLocation * start = self.locatArray.firstObject;
        [self addStartAnnotationWithCoordinate:start.coordinate];
        
        CLLocation * last = self.locatArray.lastObject;
        long dis = (long)[self.burnModel.endDate timeIntervalSince1970] - (long)[self.burnModel.startDate timeIntervalSince1970];
        NSString * lastStr = [NSString stringWithFormat:@"%.2f公里 %@",self.burnModel.totalMeter / 1000,[Utile TimeformatFromSeconds:dis]];
        [self addEndAnnotationWithCoordinate:last.coordinate String:lastStr];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self showTestPointAnnotation];
    [self deleteMapBlueView];
}
-(void)deleteMapBlueView{
    MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
    pre.showsAccuracyRing = NO;
    pre.image = [UIImage imageNamed:@"UMS_No_Location"];
    pre.fillColor = [UIColor clearColor];
    pre.strokeColor = [UIColor clearColor];
    
    [self.myMapView updateUserLocationRepresentation:pre];
}
#pragma MAMapViewDelegate
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 8.0f;
        polylineView.strokeColor = [Utile green];
        return polylineView;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AnimatedAnnotation class]])
    {
        static NSString *animatedAnnotationIdentifier = @"AnimatedAnnotationIdentifier";
        
        AnimatedAnnotationView *annotationView = (AnimatedAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:animatedAnnotationIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[AnimatedAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:animatedAnnotationIdentifier];
            
            annotationView.canShowCallout   = YES;
            annotationView.draggable        = YES;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    //    view.selected = YES;
    
    NSArray * array = [NSArray arrayWithArray:mapView.annotations];
    if (view.annotation.coordinate.latitude ==((MAPointAnnotation*)array[0]).coordinate.latitude){
        NSLog(@"这是第一个");
        //        view.canShowCallout = NO;
    }
    
    //    for (int i=0; i<array.count; i++)
    //
    //    {
    //
    //        if (view.annotation.coordinate.latitude ==((BMKPointAnnotation*)array[i]).coordinate.latitude)
    //
    //        {
    //
    //            //获取到当前的大头针  你可以执行一些操作
    //
    //        }
    //
    //        else
    //
    //        {
    //
    //            //对其余的大头针进行操作  我是删除
    //
    //            //[_mapView removeAnnotation:array[i]];
    //        }
    //
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
bool isshow = YES;
//是否显示公里数里程碑
- (IBAction)wetherShowDistanceAndTimeViewButtonClicked:(id)sender {
    
    
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

//-(void)postImageFile{
//    UIImage * image= [UIImage imageNamed:@"login_logo"];
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    image = [self.myMapView takeSnapshotInRect:rect];
//    NSData * imageData = UIImageJPEGRepresentation(image,0.5);
//    NSInteger length = [imageData length]/1024;
//    NSLog(@"图片大小:%ld",(long)length);
//    NSString * fileString = @"shareImage";
//    [imageData writeToFile:fileString atomically:YES];
//
//     NSString *theImagePath = [[NSBundle mainBundle] pathForResource:@"shareImage" ofType:@"jpg"];
//         afhttp uploadFileClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:kCOCOA_FileUPload]];
//        NSMutableURLRequest *fileUpRequest = [_uploadFileClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock:^(id formData) {
//
//                 //[formData appendPartWithFileData:imageData name:@"file" fileName:@"testImage" mimeType:@"image/png"];
//
//                 //[formData appendPartWithFileURL:[NSURL fileURLWithPath:theUpFilePath isDirectory:NO] name:@"file" fileName:@"testMusic.mp3" mimeType:@"audio/mpeg3" error:nil];
//
//                 [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"file" error:nil];
//
//             }];
//
//         self.fileUploadOp = [[AFHTTPRequestOperation alloc]initWithRequest:fileUpRequest];
//
//         [_fileUploadOp setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//                 startUp.enabled = NO;
//                [startUp setTitle:@"正在上传" forState:UIControlStateNormal];
//                 CGFloat progress = ((float)totalBytesWritten) / totalBytesExpectedToWrite;
//                 [uploadFileProgressView setProgress:progress animated:YES];
//
//             }];
//
//         [_fileUploadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                 startUp.enabled = NO;
//                 [startUp setTitle:@"完成" forState:UIControlStateNormal];
//                 NSLog(@"upload finish ---%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
//
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"error %@",error);
//                }];
//
//}

//分享按钮
- (IBAction)shareButtonClicked:(id)sender {
    NSString * shareImagePath = @"shareImagePath.jpg";
    UIImage * image;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    image = [self.myMapView takeSnapshotInRect:rect];
    if (self.shareUrl.length > 0) {
        image = [UIImage imageNamed:@"cool_ico"];
        [self shareAction:image];

    }
    else{
        NSData * imageData = UIImageJPEGRepresentation(image,0.2);
        NSInteger length = [imageData length]/1024;
        NSLog(@"图片大小:%ld",(long)length);
        
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* avatarPath = [documentPath stringByAppendingPathComponent:shareImagePath];
        
        //图片数据保存到 document
        [imageData writeToFile:avatarPath atomically:YES];
        
        NSString * filePath2=[documentPath stringByAppendingPathComponent:shareImagePath];
        
        User * user = [[UserDao sharedInstance]loadUser];
        ShareImageApi* api = [[ShareImageApi alloc]init] ;
        api.userId=user.userId ;
        api.recordId = self.recordId ;
        [api addFilePath:filePath2] ;
        [api executeHasParse:^(id jsonData) {
            NSLog(@"dizhi:%@",jsonData);
            self.shareUrl = jsonData[@"shareUrl"];
            [self shareAction:image];
        } failure:^(NSString *error) {
            [Utile showWZHUDWithView:self.navigationController.view andString:@"获取分享列表失败"];
            return;
        }];
    }

    
    
}
-(void)shareAction:(UIImage*)image{
    NSMutableArray * shareArray = [NSMutableArray arrayWithObjects:UMShareToDouban,nil];
    if ([QQApiInterface isQQInstalled]) {
        //有安装QQ
        [shareArray addObject:UMShareToQzone];
        [shareArray addObject:UMShareToQQ];
    }
    if ([WXApi isWXAppInstalled]) {
        //有安装微信
        [shareArray addObject:UMShareToWechatSession];
        [shareArray addObject:UMShareToWechatTimeline];
    }
//    if ([WeiboSDK isWeiboAppInstalled]) {
        [shareArray addObject:UMShareToSina];
//    }
   NSString * content = @"Here又有好玩的咯";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMKEY
                                      shareText:@"我在Here发现一个好玩66的卡片，来，加入进来一起玩~#Here#"
                                     shareImage:image
                                shareToSnsNames:shareArray
                                       delegate:self];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.shareUrl;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = content;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    [UMSocialData defaultData].extConfig.qqData.title = content;
    [UMSocialData defaultData].extConfig.qzoneData.title = content;
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    
}

@end
