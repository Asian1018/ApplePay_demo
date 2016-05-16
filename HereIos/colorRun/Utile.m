//
//  Utile.m
//  colorRun
//
//  Created by engine on 15/11/11.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "Utile.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation Utile
+(UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}
+(UIColor*) titleGray{
    return [Utile colorWithHex:0x9d9d9d alpha:1];
}

+(UIColor*) contentBlack{
    return [Utile colorWithHex:0x2f2f2f alpha:1] ;
}
+(UIColor*) green{
    return [Utile colorWithHex:0x42bd56 alpha:1] ;
}

+(UIColor *)orange{
    return [Utile colorWithHex:0xffad01 alpha:1] ;
}

+(UIColor*) background{
    return [Utile colorWithHex:0xf5f5f5 alpha:1] ;
}
+(UIColor *)line{
    return [Utile colorWithHex:0xeeeeee alpha:1] ;
}
/**
 NSCalendarUnitEra                = kCFCalendarUnitEra,
 NSCalendarUnitYear               = kCFCalendarUnitYear,
 NSCalendarUnitMonth              = kCFCalendarUnitMonth,
 NSCalendarUnitDay                = kCFCalendarUnitDay,
 NSCalendarUnitHour               = kCFCalendarUnitHour,
 NSCalendarUnitMinute             = kCFCalendarUnitMinute,
 NSCalendarUnitSecond             = kCFCalendarUnitSecond,
 NSCalendarUnitWeekday            = kCFCalendarUnitWeekday,
 NSCalendarUnitWeekdayOrdinal     = kCFCalendarUnitWeekdayOrdinal,
 */

+(NSInteger) getYear:(NSTimeInterval)time{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSDateComponents *comps;
     comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:detaildate];
//    NSLog(@"year=%lu,month=%lu",[comps year],[comps month]) ;
    return [comps year] ;

}
+(NSInteger)getMonth:(NSTimeInterval)time{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSDateComponents *comps;
     comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:detaildate];
    return [comps month] ;
}

+(NSInteger)getDay:(NSTimeInterval)time{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:detaildate];
    return [comps day] ;
}

+(NSString*) getTimeDesc:(NSTimeInterval)time{
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSCalendar *calendar = [NSCalendar currentCalendar] ;
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour) fromDate:detaildate];
    NSInteger hour=[comps hour] ;
    if (0<=hour&&hour<5) {
        return @"凌晨" ;
    }else if(5<=hour&&hour<12){
        return @"早上" ;
    }else if(12<=hour&&hour<18){
        return @"下午" ;
    }else{
        return @"晚" ;
    }
}

+(NSInteger)getTimeStampWithdate:(NSDate *)date{
    NSInteger lastDate = 0;
    NSString * timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    lastDate = [timeSp integerValue];
    return lastDate;
}

+(void)showPromptAlertWithString:(NSString*)str{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

/**
 NSJSONWritingPrettyPrinted  是有换位符的。
 如果NSJSONWritingPrettyPrinted 是nil 的话 返回的数据是没有 换位符的
 */
+(NSString *)changeToJsonStringWith:(id)data{
    if (data == nil) {
        return nil;
    }
    NSError *parseError = nil;
    NSString * str = @"";
    if ([NSJSONSerialization isValidJSONObject:data]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&parseError];
        str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else{
        NSLog(@"类型不对喔");
    }
    return str;
    
}

+(id)changJsonStringToObject:(NSString *)jsonStr{
    if (jsonStr == nil) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id str = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return str;
}

+(MBProgressHUD*)showHudInView:(UIView *)view{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    
    return hud;


}

+(MBProgressHUD *)showWZHUDWithView:(UIView *)view andString:(NSString *)string{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    //    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"completeIcon"]];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = string;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    return hud;
}
+(void)setLocationNoti:(NSString *)bodyString userinfos:(NSDictionary *)userinfo{
    //本地声音和震动
    
    SystemSoundID sound = kSystemSoundID_Vibrate;
    AudioServicesPlaySystemSound(sound);
    AudioServicesPlaySystemSound(1002);
    
    UILocalNotification *ln = [[UILocalNotification alloc] init];
    ln.soundName = UILocalNotificationDefaultSoundName;
    
    NSDate *date = [NSDate date];
    ln.fireDate = [date dateByAddingTimeInterval:1];
    ln.timeZone=[NSTimeZone defaultTimeZone];
    ln.applicationIconBadgeNumber = 1; //应用的红色数字
    
    //去掉下面2行就不会弹出提示框
    ln.alertBody = bodyString;//提示信息 弹出提示框
    ln.alertAction = @"查看";  //提示框按钮
    ln.userInfo = userinfo;
    [[UIApplication sharedApplication] scheduleLocalNotification:ln];
    
}

+(NSString*)TimeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

+(UIView*)showHereView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 40)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    label.text = @"--  Here  --";
    label.textColor = [UIColor lightGrayColor];
    return view;
}
+(void) showTipAlert:(UIViewController*) viewController title:(NSString*)title message:(NSString *)message {
    NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
       UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:otherAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+(UIView*)showEmptyViewWithView:(UITableView*)tableView title:(NSString*)title image:(UIImage*)image{
    WYEmptyTableFooterView * empty = [WYEmptyTableFooterView emptyTableFooterViewWithTableView:tableView];
    if (image) {
        empty.playHolderImageView.image = image;
    }
    if (title.length > 0) {
        empty.placeholderLabel.text = title;
    }
    return empty;
}

+(CGSize)getSizeWithString:(NSString *)contend font:(CGFloat)font width:(CGFloat)width{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize Hsize = [contend boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return Hsize;
}

@end
