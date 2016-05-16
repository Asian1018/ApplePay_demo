//
//  AppDelegate.m
//  colorRun
//
//  Created by engine on 15/10/20.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "RDVTabBarController.h"
#include "RDVTabBarItem.h"
//#include "UMSocial_Sdk_4.3/Header/UMSocial.h"
#import "DCFSQLite.h"
#import "User.h"
#import "FMDBManager.h"
#import <MAMapKit/MAMapKit.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
//#import "UMSocialSinaSSOHandler.h"
#import "AMapLocationServices.h"
#import "UMessage.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMFeedback.h"
#import "MobClick.h"
#import "HomeCardViewController.h"
#import "ShowResultViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? 1 : 0
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
-(void)setUMessageWith:(NSDictionary* )launchOptions{
    [UMessage startWithAppkey:UMKEY launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    }
    else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:NO];
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [UMFeedback didReceiveRemoteNotification:notificationDict];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动图延长3秒
    //    [NSThread sleepForTimeInterval:3];
    [self setUMessageWith:launchOptions];
    [MobClick startWithAppkey:UMKEY reportPolicy:BATCH channelId:nil];
    [UMFeedback setAppkey:UMKEY];
    [MAMapServices sharedServices].apiKey = GAODE_MAP_KEY ;
    [AMapLocationServices sharedServices].apiKey = GAODE_MAP_KEY;
    [UMSocialData setAppKey:UMKEY];
    
    [SMSSDK registerApp:@"f01dda0b8c39"
             withSecret:@"8c9d38922e29cf15d4bbff84bd0d56b9"];
    [self setRootView] ;
    [self setUpSNSPlatform] ;
    return YES;
}
-(void) testResultView{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ShowResultViewController *result =[borad instantiateViewControllerWithIdentifier:@"showResultViewController"] ;
    result.rewardType = 0;
    result.rewardBewrite = @"ee";
    result.date=@"2016-01-18";
    ActivityDetail* detail = [[ActivityDetail alloc]init] ;
    detail.claim=0 ;
    detail.isReward=0 ;
    detail.period=2000;
    detail.meter=5000 ;
    BurningModel* model = [[BurningModel alloc] init] ;
    model.totalMeter=8300 ;
    model.startDate=[NSDate date]  ;
    model.endDate= [NSDate dateWithTimeIntervalSinceNow:2600] ;
    result.actvityDetail=detail ;
    result.model = model ;
    result.status=0 ;
    self.viewController = result;
    self.window.rootViewController=self.viewController ;
}
-(void) setRootView{
    NSLog(@"setRootView start") ;
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *coolController=[borad instantiateViewControllerWithIdentifier:@"coolnavigationController"] ;
    //    coolController.navigationBar.backgroundColor=[self colorWithHex:0xFFFFFF alpha:0.5] ;
    UIStoryboard * cardStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:[NSBundle mainBundle]];
    HomeCardViewController * card = [cardStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([HomeCardViewController class])];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:card];
    UIViewController *buringViewController = [borad instantiateViewControllerWithIdentifier:@"buringNavigationViewController"] ;
    UIViewController *mineViewController = [borad instantiateViewControllerWithIdentifier:@"mineNavigationController"] ;
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[coolController,nav,buringViewController,mineViewController]];
    [self setTabItem:tabBarController] ;
    self.viewController = tabBarController;
    self.window.rootViewController=self.viewController ;
    NSLog(@"setRootView end") ;
}
-(void) setUpSNSPlatform{
    //微信分享设置
    [UMSocialWechatHandler setWXAppId:@"wx73a1229aa7f156bd" appSecret:@"0b4bba527bf9fe73e64d0dc47bb79606" url:@"http://baidu.com"];
    //QQ
    [UMSocialQQHandler setQQWithAppId:@"1104958979" appKey:@"g4zlb63eWBNolSqn" url:@"http://baidu.com"];
    
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:NO];
    //新浪微博分享
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"852162997" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //设置系统的默认tintColor
    if ([self.window respondsToSelector:@selector(tintColor)]) {
        //        self.window.tintColor =[UIColor colorWithRed:66.0f/255 green:197.0f/255 blue:187.0f/255 alpha:1.0f];
        self.window.tintColor =[Utile green];
        
    }
    
}
//-(void) initDatabase{
//    FMDatabase *db = [[FMDBManager sharedInstance]getDb] ;
//    User* user = [[User alloc] init];
//    [self createTableName:db tableName:@"User" model:user] ;
//}

//-(BOOL) createTableName:(FMDatabase*) database tableName:(NSString*) tableName model:(BaseModel*) model{
//    NSString* createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName] ;
//    for (NSString* colum in [model PropertyKeys]) {
//        createSql=[createSql stringByAppendingFormat:@"%@ TEXT,",colum] ;
//    }
//    createSql = [createSql substringToIndex:createSql.length-1] ;
//    createSql=[createSql stringByAppendingString:@");"] ;
//    //    NSLog(@"createTable:%@",createSql) ;
//    BOOL ok =[database executeStatements:createSql] ;
//    if (ok) {
//        NSLog(@"create success") ;
//    }else{
//        NSLog(@"creat fail") ;
//    }
//    return ok;
//    
//}

//- (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
//{
//    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
//                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
//                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
//}

-(void) setTabItem:(RDVTabBarController *)tabBarController{
    NSArray *titles = @[@"Here",@"卡片",@"燃烧",@"我"] ;
    NSArray *itemImage=@[@"cool",@"sign",@"burning",@"mine"];
    NSInteger index = 0 ;
    UIImage *image = [UIImage imageNamed:@"tabbar_bg"] ;
    NSDictionary *selectAttribute = @{NSForegroundColorAttributeName:[Utile green],NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSDictionary *unselectAttribute = @{NSForegroundColorAttributeName:[Utile colorWithHex:0xB1B1B1 alpha:1.0],
                                        NSFontAttributeName:[UIFont systemFontOfSize:14]};
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.selectedTitleAttributes=selectAttribute;
        item.unselectedTitleAttributes=unselectAttribute ;
        [item setBackgroundSelectedImage:image withUnselectedImage:image];
        UIImage *selectImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_press",[itemImage objectAtIndex:index]]];
        UIImage *unSelectImage = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%@_nor",[itemImage objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectImage withFinishedUnselectedImage:unSelectImage] ;
        [item setTitle:[titles objectAtIndex:index]] ;
        item.badgeTextColor = [Utile green];
        index++;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //     [Utile setLocationNoti:@"测试本地通知......" userinfos:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"支付宝结果 = %@",resultDic);
        [Utile showWZHUDWithView:self.window andString:@"查看回调结果"];
    }];
    return  [UMSocialSnsService handleOpenURL:url];
    //    if (result == FALSE) {
    //        //调用其他SDK，例如支付宝SDK等
    //        NSLog(@"回调失败");
    //    }
    //    return result;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "zhidian.colorRun" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"colorRun" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"colorRun.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
}

#pragma 获取设备 token
//ios8通知
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * Token = [NSString stringWithFormat:@"%@",deviceToken];
    Token = [Token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];//将其中的<>去掉
    Token = [Token stringByReplacingOccurrencesOfString:@" " withString:@""];//将其中的空格去掉
    if (Token.length > 0) {
        [[NSUserDefaults standardUserDefaults]setObject:Token forKey:DEVICE_TOKEN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    //    if ([[UserDao sharedInstance]loadUser].userId.length > 0) {
    [self initService:Token];
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"error = %@", error);
            NSLog(@"responseObject = %@", responseObject);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"错误是：%@", error);
}
#warning 以后版本修改要记得修改这里versionCode的信息
-(void) initService:(NSString*)token{
    NSString * Vstring = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    //    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    NSLog(@"手机系统版本: %@", phoneVersion);
    InitApi* api = [[InitApi alloc]init ] ;
    UIDevice *device =[[UIDevice alloc]init] ;
    api.deviceId = [device.identifierForVendor.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""] ;
    api.versionCode = 2;
    api.versionName= Vstring ;
    api.clientType = 2;
    api.deviceToken = token ;
    api.systemVersion = phoneVersion;
    api.deviceModel = deviceName;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        [api excuteWhithSuccess:^(NSURLSessionDataTask *response, id responseDate) {
            NSLog(@"上传 token=%@",responseDate) ;
            if ([responseDate[@"code"] isEqualToString:@"0"]) {
                //请求成功
                NSDictionary * dic = responseDate[@"data"];
                if ([dic[@"status"] integerValue] == 1) {
                    //有新版本
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 更新界面
                        UIAlertView * al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有新版本喔.你要去下载吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往AppStore", nil];
                        [al show];
                        al.tag = 100;
                    });
                }
            }
        } failure:^(NSURLSessionDataTask *response, NSError *error) {
            NSLog(@"error:%@",error.description) ;
        }];
    });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            NSString * str = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@?mt=8",HERE_APPID];
            NSURL * url = [NSURL URLWithString:str];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            else{
                [Utile showPromptAlertWithString:@"AppStore miss"];
            }
        }
    }
    
}







@end
