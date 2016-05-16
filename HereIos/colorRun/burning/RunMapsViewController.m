
#import "RunMapsViewController.h"
#import "RDVTabBarController.h"
#import <AVFoundation/AVFoundation.h>
#import "FastAnimationWithPOP/FastAnimationWithPop.h"
#import <CoreLocation/CoreLocation.h>
#import "SportContrailViewController.h"
#import "MZTimerLabel.h"
#import "BurningApi.h"
#import "LoginViewController.h"
#import "AMapLocationManager.h"
#import "BaseMapView.h"
#define LOCATION_METER 1000
@interface RunMapsViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,AMapLocationManagerDelegate>{
    NSTimer * runTimer;
    UIView * countBackwardsView;
    UIButton * downButton;
    CGPoint viewCenterPoint;
    BOOL shouldLoad;
    BOOL isRecoding; //是否在记录经纬度
    CLLocationManager* locationMgr;
    UIPanGestureRecognizer * recognizer;
    AMapLocationManager * mapLocation;
    MAPolyline * myLine;
    UILabel * la;
    NSMutableArray * PolylineArray;
    MAPolyline * lastLine;
    NSInteger mileCount;
    BOOL needLocation;
    NSInteger lastToutalMeter; // 上一时间点的总路程(30s前)
    HereRunRecorderTrack* queque ;
    enum RunStatus status ;
}
@property (weak, nonatomic) IBOutlet UIButton *startWalkButton;

@property (weak, nonatomic) IBOutlet BaseMapView *GaoDeMapView;
@property (weak, nonatomic) IBOutlet UIView *walkingView;
@property (weak, nonatomic) IBOutlet UIView *signalView;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel; //总公里(自己拼字体样式)
@property (weak, nonatomic) IBOutlet MZTimerLabel *timeLabel;//用时
@property (weak, nonatomic) IBOutlet UILabel *speedLabel; //平均速度
@property (weak, nonatomic) IBOutlet UILabel *perMileLabel; //配速
@property (weak, nonatomic) IBOutlet UIView *stopView;
@property (weak, nonatomic) IBOutlet UIButton * finishButton;
@property (weak, nonatomic) IBOutlet UIButton * continueButton;
@property (weak, nonatomic) IBOutlet UIView *FCView;
@property (strong, nonatomic) NSMutableArray * JsonArray;
@property (nonatomic ) NSInteger runCount;
@property(nonatomic ,strong) NSArray * countArray;
@property(nonatomic, strong)NSMutableArray * speedArray;
@property (nonatomic ) NSInteger currentMeter;//30秒间隔的路程长
@property(nonatomic,strong) NSTimer * speedTimer;
@end
#define TIME_STAMP 30  //循环间隔
@implementation RunMapsViewController
CGFloat const gestureMinimumTranslation = 50.0 ;

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _GaoDeMapView = nil;
    [_GaoDeMapView removeFromSuperview];
    if (_speedTimer.isValid) {
        [_speedTimer invalidate];
        _speedTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mileCount = 1;
    needLocation = YES;
    PolylineArray = [NSMutableArray array];
    //    [self testLabel:@"还没数据"];
    if (self.sportMode  == 1) {
        [self.startWalkButton setTitle:@"开始跑步" forState:UIControlStateNormal];
    }
    self.burnModel = [[BurningModel alloc]init];
    self.burnModel.sportMode = self.sportMode;
    self.burnModel.totalMeter = 0;
    self.locationArray = [NSMutableArray array];
    isRecoding = NO;
    self.timeLabel.timerType =  MZTimerLabelTypeStopWatch;
    self.timeLabel.timeFormat = @"HH:mm:ss";
   
    queque = [[[HereRunRecorderTrack alloc]init]initWhithLength:5] ;
    self.JsonArray = [NSMutableArray array];
    self.speedArray = [NSMutableArray array];
    _GaoDeMapView.userTrackingMode = MAUserTrackingModeFollow;
    _GaoDeMapView.showsUserLocation = YES;
    _GaoDeMapView.showsCompass = NO;
    _GaoDeMapView.showsScale = NO;
    _GaoDeMapView.delegate = self;
    _GaoDeMapView.allowsBackgroundLocationUpdates = YES;
    _GaoDeMapView.pausesLocationUpdatesAutomatically = NO;
    [_GaoDeMapView setZoomLevel:14.1 animated:YES];
    
    mapLocation = [[AMapLocationManager alloc] init];
    mapLocation.delegate = self;
    mapLocation.allowsBackgroundLocationUpdates = YES;
    mapLocation.distanceFilter = 1;
    mapLocation.pausesLocationUpdatesAutomatically = NO;
    
    self.countArray = [NSArray arrayWithObjects:@"countdown_three",@"countdown_two",@"countdown_one", nil];
    self.countView.hidden = YES;
    self.stopView.hidden = YES;
    self.FCView.hidden = YES;
    shouldLoad = YES;
    
    recognizer = [[ UIPanGestureRecognizer alloc] initWithTarget: self action: @selector (handleSwipe:)];
    recognizer.maximumNumberOfTouches = 1;
    [ self.stopView addGestureRecognizer:recognizer];
    
    [self insteadBackIcon];
   // [self testRecorder] ;
}

-(void) testRecorder{
    GetSportHistory * history = [[GetSportHistory alloc]init];
    history.userId = 35 ;
    history.recordId = 124 ;
    [history executeHasParse:^(id jsonData) {
        NSString* track = jsonData[@"data"] ;
        NSArray* locationArrray = [Utile changJsonStringToObject:track];
        for (id dictionary in locationArrray) {
           // id dictionary=[track objectAtIndex:i];
            JsobStringModel * json = [[JsobStringModel alloc]init];
            for (id key in [json PropertyKeys]) {
                [json setValue:[dictionary objectForKey:key] forKey:key];
                
            }
            CLLocation * location = [[CLLocation alloc]initWithLatitude:json.latitude longitude:json.longitude];

            
            [self trackWithLocation:location] ;
            [self calculatWithLocation:location] ;
        }
    } failure:^(NSString *error) {
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    viewCenterPoint = self.stopView.center;
    [self deleteMapBlueView];
    
}
/**
 *  everyDay i go home
 */
-(void)insteadBackIcon{
    self.countView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.countView.layer.borderWidth = 1;
    UIBarButtonItem * buttons = [[UIBarButtonItem alloc]initWithTitle:@"结束" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = buttons;
}

-(void)wetherFromSport{
    if (self.activityId > 0) {
        //活动过来
            if (self.burnModel.totalMeter < self.activityDetail.meter) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本次任务还没完成,要结束吗？" delegate:self cancelButtonTitle:@"离开" otherButtonTitles:@"取消", nil];
                [alert show];
                alert.tag = 3;
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在记录中，是否结束记录离开页面？" delegate:self cancelButtonTitle:@"离开" otherButtonTitles:@"取消", nil];
                [alert show];
                alert.tag = 2;
            }
        }
    else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在记录中，是否结束记录离开页面？" delegate:self cancelButtonTitle:@"离开" otherButtonTitles:@"取消", nil];
        [alert show];
        alert.tag = 2;
    }

}
-(void)backAction{
    if (!isRecoding) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self wetherFromSport];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            NSLog(@"结束记录返回上一页面");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag == 100){
        if (buttonIndex == 0) {
            //结束记录，返回上层
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            self.title = @"记录中";
        }
        
    }
    else if (alertView.tag == 3){
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
    
    }
    else if (alertView.tag == 4){
        if (buttonIndex == 0) {
            [self postDataAfterFinishWalking];
            if (_speedTimer.isValid) {
                [_speedTimer invalidate];
                _speedTimer = nil;
            }

        }
    
    }
    

}
#pragma mark - location Delegate
-(void)testLabel:(NSString* )string{
    if (!la) {
        la = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, 60)];
        la.numberOfLines = 4;
        la.textColor = [UIColor redColor];
        [self.GaoDeMapView addSubview:la];
        la.text = @"还没数据";
        la.textAlignment = NSTextAlignmentCenter;
        return;
    }
    la.text = string;
};
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSString * speedStr = [NSString stringWithFormat:@"速度:%f  ",newLocation.speed];
    long dis = (long)[newLocation.timestamp timeIntervalSince1970] -  (long)[oldLocation.timestamp timeIntervalSince1970];
    NSString * timeStr = [NSString stringWithFormat:@"时间间隔:%ld  ",dis];
    MAMapPoint point1 = MAMapPointForCoordinate(newLocation.coordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(oldLocation.coordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    NSLog(@"两点距离是：%f",distance);
    NSString * disString = [NSString stringWithFormat:@"距离:%f  ",distance];
    [self testLabel:[NSString stringWithFormat:@"%@ %@ %@",speedStr,timeStr,disString]];
    
}
-(NSString *)getPerMileSpeedWith:(CGFloat)meter{
    //    NSString * string = @"0.0";
    long dis = (long)[[NSDate date] timeIntervalSince1970] - (long)[self.burnModel.lastDate timeIntervalSince1970];
    NSLog(@"时间间隔是:%ld秒",dis);
    if (dis == 0) {
        return self.perMileLabel.text;
    }
    CGFloat minPerMile = 1000 / meter * dis / 60;
    return [self getStringWith:minPerMile];;
}
-(NSString *)getStringWith:(CGFloat)mile{
    NSString * string = @"0.00";
    if (mile == 0 ) {
        return string;
    }
    int decimalNum = 2; //保留的小数位数
    NSNumber * number = [NSNumber numberWithFloat:mile];
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:decimalNum];
    NSLog(@"result:%@", [nFormat stringFromNumber:number]);
    string = [NSString stringWithFormat:@"%@",[nFormat stringFromNumber:number]];
    NSArray * arr = [string componentsSeparatedByString:@"."];
    CGFloat secondF = [arr.lastObject floatValue] * 0.6;
    NSString * secondString = [[NSString stringWithFormat:@"%f",secondF] componentsSeparatedByString:@"."].firstObject;
    string = [NSString stringWithFormat:@"%@.%@",arr.firstObject,secondString];
    return string;
}

-(NSString *)getPerHourSpeedAction:(CGFloat)meter{
    //    NSString * string = @"0.0";
    long dis = (long)[[NSDate date] timeIntervalSince1970] - (long)[self.burnModel.lastDate timeIntervalSince1970];
    NSLog(@"时间间隔是:%ld秒",dis);
    if (dis == 0) {
        return self.speedLabel.text;
    }
    CGFloat lastMile = (meter * 3600) / (dis * 1000);
    return [self getStringWith:lastMile];
}

//获取定位失败回调方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location error!");
    
}

- ( void )handleSwipe:( UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView: self .view];
    if (gesture.state == UIGestureRecognizerStateBegan ) {
        
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (translation.y > 0  ) {
            CGFloat y = gesture.view.center.y + translation.y;
            //            NSLog(@"point:%f",gesture.view.center.y);
            gesture.view.center = CGPointMake(viewCenterPoint.x, y);
            if (y > (viewCenterPoint.y  + gestureMinimumTranslation )) {
                NSLog(@"完成下拉");
                self.stopView.hidden = YES;
                self.FCView.hidden = NO;
                gesture.enabled = NO;
                shouldLoad = NO;
                [self.finishButton startFAAnimation];
                [self.continueButton startFAAnimation];
                status=PAUSE ;
                [self pauseLocation] ;
                [self.timeLabel pause];
                self.title = @"运动暂停";
                self.burnModel.endDate = [NSDate date];
                if (_speedTimer) {
                    [_speedTimer setFireDate:[NSDate distantFuture]];
                }
                return;
            }
            [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
            
        }
        else {
            NSLog(@"stop");
            return;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ) {
        
        if (shouldLoad == YES) {
            self.stopView.center = viewCenterPoint;
            
        }
        
    }
}
//修改当前位置蓝点的style
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.0f;
        polylineView.strokeColor = [Utile green];
        return polylineView;
    }
    return nil;
}

#pragma AMapLocationManagerDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"destination"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
//#warning 计算配速改为30秒一个循环来计算(需要测试)
-(void)accoutSpeedAndShow{
    //30秒一循环
    if (!self.currentMeter) {
        if (self.burnModel.totalMeter > 0) {
            self.currentMeter = self.burnModel.totalMeter;
            lastToutalMeter = self.burnModel.totalMeter;
        }
        else return;
    }
    else{
        self.currentMeter = self.burnModel.totalMeter - lastToutalMeter;
    }
//#warning 计算配速改为30秒一个循环来计算(需要测试)
    if (self.currentMeter < 15) {
        return;
    }
    lastToutalMeter = self.burnModel.totalMeter;
    self.milesLabel.text = [NSString stringWithFormat:@"%.2f",self.burnModel.totalMeter / 1000];
    double mile = [[NSString stringWithFormat:@"%ld",(long)self.currentMeter] doubleValue];
    CGFloat totalspeed = (mile / 1000) * (3600 / TIME_STAMP);
    //    self.speedLabel.text = [NSString stringWithFormat:@"%2ld",(self.currentMeter / 1000) * (3600 / TIME_STAMP)];
    self.speedLabel.text = [self getStringWith:totalspeed];
    
    CGFloat perSpeed = (1000 * 1.0 / [[NSString stringWithFormat:@"%ld",(long)self.currentMeter]floatValue]) * (TIME_STAMP*1.0/60);
    self.perMileLabel.text = [self getStringWith:perSpeed];
    
}
-(void) drawTrack:(NSArray*) locationPoint{
    CLLocationCoordinate2D commonPolylineCoords[locationPoint.count];
    for (int i = 0; i< locationPoint.count; i++) {
        CLLocation *point = [locationPoint objectAtIndex:i];
        commonPolylineCoords[i].latitude = point.coordinate.latitude;
        commonPolylineCoords[i].longitude = point.coordinate.longitude;
    }
    myLine = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:locationPoint.count];
    [self.GaoDeMapView addOverlay: myLine];
}
-(void) trackWithLocation:(CLLocation*) location{
    [queque enqueque:location];
    NSArray* locationPoint=[queque allObject] ;
    if (locationPoint!=nil) {
        [self drawTrack:locationPoint] ;
        [queque cleanQueque];
    }
}
-(void) pauseLocation{
    NSArray* locationPoint=[queque pauseRecorder] ;
    if (locationPoint.count>0) {
        [self drawTrack:locationPoint] ;
        [queque cleanQueque];
    }
}
-(void) calculatWithLocation:(CLLocation*) location{
    [self.locationArray addObject:location];
    JsobStringModel * model = [[JsobStringModel alloc]init];
    model.latitude = location.coordinate.latitude;
    model.longitude = location.coordinate.longitude;
    model.time = [Utile getTimeStampWithdate:[NSDate date]];
    
    if (self.burnModel.startLat <= 0) {
        self.burnModel.startLat = location.coordinate.latitude;
        self.burnModel.startLong = location.coordinate.longitude;
        self.burnModel.lastDate = [NSDate date];
        model.distance = 0;
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = location.coordinate;
        pointAnnotation.title = @"起点";
        
        [_GaoDeMapView addAnnotation:pointAnnotation];
        
    }
    else{
        if (self.burnModel.startLat == location.coordinate.latitude && self.burnModel.startLong == location.coordinate.longitude) {
            return;
        }
        CLLocation * cool = [[CLLocation alloc]initWithLatitude:self.burnModel.startLat longitude:self.burnModel.startLong];
        MAMapPoint point1 = MAMapPointForCoordinate(cool.coordinate);
        MAMapPoint point2 = MAMapPointForCoordinate(location.coordinate);
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        NSLog(@"两点距离是：%f",distance);
        long secondDis = (long)[[NSDate date] timeIntervalSince1970] - (long)[self.burnModel.lastDate timeIntervalSince1970];
        CGFloat perSpeed = (distance / 1000) * (3600 * 1.0/ secondDis);
        //时速判断:大于22km/h 或者小于1.5km/h 的点就放弃
        NSLog(@"两点时速：%.2f",perSpeed);
        if (perSpeed > 22 || perSpeed < 1.5) {
            return;
        }
        
        
        if ([[self getPerHourSpeedAction:distance] floatValue] > 20) {
            //超过20KM/小时,都是不符合要求的数据,扔掉
            return;
        }
        //        NSString * speedString = [self getPerHourSpeedAction:distance];
        NSString * perMileString = [self getPerMileSpeedWith:distance];
        self.burnModel.totalMeter = self.burnModel.totalMeter + distance;
        //        self.milesLabel.text = [NSString stringWithFormat:@"%.2f",self.burnModel.totalMeter];
        if ([perMileString floatValue] > 1) {
            [self.speedArray addObject:perMileString];
        }
        //        self.speedLabel.text = speedString;
        //        self.perMileLabel.text = perMileString;
        self.burnModel.startLat = location.coordinate.latitude;
        self.burnModel.startLong = location.coordinate.longitude;
        model.distance = distance;
        self.burnModel.lastDate = [NSDate date];
        if (self.burnModel.totalMeter > mileCount * LOCATION_METER) {
            if (needLocation) {
                NSString* disTime = @"未知时间";
                long disSecond = (long)[[NSDate date] timeIntervalSince1970] - (long)[self.burnModel.startDate timeIntervalSince1970];
                if (disSecond > 0 ) {
                    NSString *str_hour = [NSString stringWithFormat:@"%02ld",disSecond/3600];
                    //format of minute
                    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(disSecond%3600)/60];
                    //format of second
                    NSString *str_second = [NSString stringWithFormat:@"%02ld",disSecond%60];
                    if (disSecond < 3600) {
                        disTime = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
                    }
                    else{
                        disTime = [NSString stringWithFormat:@"%@小时%@分钟%@秒",str_hour,str_minute,str_second];
                    }
                }
                NSString * title = [NSString stringWithFormat:@"哟~~~你已运动%ld公里，用时%@",(long)mileCount,disTime];
                [Utile setLocationNoti:title userinfos:nil];
                mileCount ++;
            }
        }
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    for (id key in [model PropertyKeys]) {
        [dic setValue:[model valueForKey:key] forKey:key];
        
    }
    [self.JsonArray addObject:dic];

}
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"经度 : %f,维度: %f",location.coordinate.latitude,location.coordinate.longitude);
    [self parseLocation:location] ;
}

-(void) parseLocation:(CLLocation*) location{
    if (status==RUN) {
        [self trackWithLocation:location] ;
        [self calculatWithLocation:location] ;
    }

}

/**
 *  去掉地图的蓝色经纬度圈
 */
-(void)deleteMapBlueView{
    MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
    pre.showsAccuracyRing = NO;
    pre.image = [UIImage imageNamed:@"UMS_No_Location"];
    pre.fillColor = [UIColor clearColor];
    pre.strokeColor = [UIColor clearColor];
    
    [self.GaoDeMapView updateUserLocationRepresentation:pre];
}

-(void)mapViewDidStopLocatingUser:(MAMapView *)mapView{
    [self deleteMapBlueView];
    
}

//开始走路按钮
- (IBAction)startWalkingAction:(id)sender {
    isRecoding = YES;
    status=RUN ;
    [self makeStartWalkingViewCountBackwards];
    
}

-(void)makeStartWalkingViewCountBackwards{
    countBackwardsView = [[UIView alloc]initWithFrame:self.view.frame];
    countBackwardsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.view addSubview:countBackwardsView];
    downButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(countBackwardsView.frame) - 50, CGRectGetMidY(countBackwardsView.frame) - 50, 100, 100)];
    downButton.userInteractionEnabled = NO;
    [downButton setImage:[UIImage imageNamed:@"countdown_ready"] forState:UIControlStateNormal];
    [countBackwardsView addSubview:downButton];
    //    [self soundWithString:@"准备"];
    //    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCounting) userInfo:nil repeats:NO];
    [self startCounting];
}

-(void)startCounting{
    if (!runTimer) {
        self.runCount = 0;
        [self showAnimationWithLayer:downButton.layer];
        runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showBackCount:) userInfo:nil repeats:YES];
        
    }
}

-(void)showAnimationWithLayer:(CALayer*)layer{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:4.0];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 1;
    [layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}
-(void)showBackCount:(NSTimer *)timer {
    if (self.runCount < 3) {
        //        [self soundWithString:[self.countArray objectAtIndex:self.runCount]];
        [downButton setImage:[UIImage imageNamed:[self.countArray objectAtIndex:self.runCount]] forState:UIControlStateNormal];
        [self showAnimationWithLayer:downButton.layer];
        self.runCount++;
    }
    else{
        [timer invalidate];
        timer = nil;
        //        [self soundWithString:@"开始"];
        [self.timeLabel start];
        self.walkingView.hidden = YES;
        self.signalView.hidden = YES;
        self.countView.hidden = NO;
        self.stopView.hidden = NO;
        //        self.FCView.hidden = NO;
        self.title = @"记录中";
        self.burnModel.startDate = [NSDate date];
        [mapLocation startUpdatingLocation];
        //        [locationMgr startUpdatingLocation];
        _speedTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_STAMP target:self selector:@selector(accoutSpeedAndShow) userInfo:nil repeats:YES];
        [_speedTimer fire];
        if (countBackwardsView) {
            [countBackwardsView removeFromSuperview];
            countBackwardsView = nil;
            
        }
        [self.stopView startFAAnimation];
    }
    
}
/**
 *  播放语音
 */
-(void)soundWithString:(NSString*) string{
    if( [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
        utterance.rate *= 1;
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        //获取当前系统语音
        NSString *preferredLang = @"zh-hk";
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:[NSString stringWithFormat:@"%@",preferredLang]];
        utterance.voice = voice;
        [synth speakUtterance:utterance];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
}
//完成运动
- (IBAction)finishSportButtonClicked:(UIButton *)sender {

//#warning 计算配速改为30秒一个循环来计算(需要测试)
    [mapLocation stopUpdatingLocation];
    //|| self.burnModel.totalMeter < 10
    if (self.locationArray.count < 2 || self.burnModel.totalMeter < 10) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                        message:@"没有记录到数据，要结束吗?"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消",
                               nil];
        [alert show];
        alert.tag = 100;
        return;
    }
//#warning 测试....
    if (self.activityId > 0) {
        //活动过来
        if (self.burnModel.totalMeter < self.activityDetail.meter) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本次任务还没完成,要结束吗？" delegate:self cancelButtonTitle:@"结束" otherButtonTitles:@"取消", nil];
            [alert show];
            alert.tag = 4;
            return;
        }
    }
    
    [self postDataAfterFinishWalking];
    if (_speedTimer.isValid) {
        [_speedTimer invalidate];
        _speedTimer = nil;
    }
    // to do
}
-(NSString*)getLastString:(NSString*)baseStr{
    NSString * last = @"";
    NSArray * arr = [baseStr componentsSeparatedByString:@"."];
    last = [NSString stringWithFormat:@"%@'%@\"",arr.firstObject,arr.lastObject];
    return last;
}

NSInteger sortByID(id obj1, id obj2, void *context){
    NSString *str1 =(NSString*) obj1; // ibj1 和 obj2 来自与你的数组中，其实，个人觉得是苹果自己实现了一个冒泡排序给大家使用
    NSString *str2 =(NSString *) obj2;
    if ([str1 floatValue] < [str2 floatValue]) {
        return NSOrderedDescending;
    }
    else if([str1 floatValue] == [str2 floatValue])
    {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

-(NSArray *)SortMutableArr:(NSMutableArray *)arr{
    NSArray *sortedArray =[arr sortedArrayUsingFunction:sortByID context:nil];
    return sortedArray;
}
//上传数据到服务器
-(void)postDataAfterFinishWalking{
    User * user = [[UserDao sharedInstance]loadUser];
    NSArray * arr = [self SortMutableArr:self.speedArray];
    self.burnModel.maxPace = [NSString stringWithFormat:@"%@",[self getLastString:arr.lastObject]];
    self.burnModel.minPace = [NSString stringWithFormat:@"%@",[self getLastString:arr.firstObject]];
    if ([[NSString stringWithFormat:@"%@",arr.lastObject] isEqualToString:@"0.00"]) {
        //去掉无用数据
        self.burnModel.maxPace = [NSString stringWithFormat:@"%@",[self getLastString:[arr objectAtIndex:arr.count - 2]]];
    }
    long dis = (long)[self.burnModel.endDate timeIntervalSince1970] - (long)[self.burnModel.startDate timeIntervalSince1970];
    
    self.burnModel.pace = [NSString stringWithFormat:@"%.2f",3600/ dis * self.burnModel.totalMeter / 1000];
    //    NSString * str = [self getLastString:[NSString stringWithFormat:@"%.2f",self.burnModel.totalMeter]];
    self.burnModel.avgPace = [NSString stringWithFormat:@"%@",[self getLastString:[NSString stringWithFormat:@"%.2f",1000 /  self.burnModel.totalMeter * dis / 60]]];
    
    PostBurningApi * bruning = [[PostBurningApi alloc]init] ;
    bruning.userId = user.userId;
    bruning.deviceType = IOS_DEVICE_TYPE;
    bruning.sportType = self.sportType;
    bruning.sportMode = self.burnModel.sportMode;
    bruning.startTime = [Utile getTimeStampWithdate:self.burnModel.startDate];
    bruning.endTime = [Utile getTimeStampWithdate:[NSDate date]];
    bruning.meter = self.burnModel.totalMeter;
    bruning.pace = self.burnModel.pace;
    bruning.avgPace = self.burnModel.avgPace;
    bruning.maxPace = self.burnModel.maxPace;
    bruning.minPace = self.burnModel.minPace;
    bruning.status = 0;
    bruning.data = [Utile changeToJsonStringWith:self.JsonArray];
    NSLog(@"json字符串:%@",bruning.data);
    if (self.recordId) {
        bruning.recordId = self.recordId;
    }
    if (self.activityId) {
        bruning.activityId = self.activityId;
    }
    if (self.sportType == 2) {
        //卡片进来
        bruning.activityId = self.models.cardId;
    }
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [bruning executeHasParse:^(id jsonData) {
         hud.hidden = YES;
        UIStoryboard *borad = [UIStoryboard storyboardWithName:@"SportResult" bundle:[NSBundle mainBundle]];
        SportContrailViewController * sport=[borad instantiateViewControllerWithIdentifier:NSStringFromClass([SportContrailViewController class])] ;
        sport.locatArray = self.locationArray;
        sport.burnModel = self.burnModel;
        sport.fromType = @"0";
        sport.recordId =[[NSString stringWithFormat:@"%@",jsonData[@"recordId"]]integerValue];
        sport.activityDetail = self.activityDetail;
        sport.rewardBewrite = jsonData[@"rewardBewrite"];
        sport.rewardType = [[NSString stringWithFormat:@"%@",jsonData[@"rewardType"]]integerValue];
        sport.status = [[NSString stringWithFormat:@"%@",jsonData[@"status"]]integerValue] ;
        sport.date=jsonData[@"time"];
        //逻辑是错误的
        NSLog(@"奖励类型:%@",sport.rewardType > 0 ? @"实物类型" : @"虚拟类型");
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        self.navigationItem.backBarButtonItem = barButtonItem;
        sport.cardMeter = self.cardMeter;
        sport.models = self.models;
        [self.navigationController pushViewController:sport animated:YES] ;
    } failure:^(NSString *error) {
        [Utile showPromptAlertWithString:error.description];
        hud.hidden = YES;
    }];
}

//运动继续
- (IBAction)continueSportButtonClicked:(UIButton *)sender {
    self.stopView.hidden = NO;
    self.FCView.hidden = YES;
    recognizer.enabled = YES;
    status=RUN ;
    self.stopView.center = viewCenterPoint;
    if (![self.timeLabel counting]) {
        [self.timeLabel start];
    }
    [self.stopView startFAAnimation];
    self.title = @"运动继续";
//    [mapLocation startUpdatingLocation];
    if (_speedTimer) {
        [_speedTimer setFireDate:[NSDate date]];
    }
}
-(void)dealloc{
    
    if (_speedTimer.isValid) {
        [_speedTimer invalidate];
        _speedTimer = nil;
    }
    
}
@end
