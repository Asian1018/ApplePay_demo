//
//  Utile.h
//  colorRun
//
//  Created by engine on 15/11/11.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface Utile : NSObject
+(UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue ;
+(NSInteger) getYear:(NSTimeInterval) time ;
+(NSInteger) getMonth:(NSTimeInterval) time ;
+(NSInteger) getDay:(NSTimeInterval) time ;
+(NSString*) getTimeDesc:(NSTimeInterval) time ;
+(NSInteger)getTimeStampWithdate:(NSDate *)date; //date 转换成时间戳
+(void)showPromptAlertWithString:(NSString*)str;
/**
 *  把对象转换成json字符串
 */
+(NSString *)changeToJsonStringWith:(id)data;
/**
 *  json字符串转换成字符串
 */
+(id)changJsonStringToObject:(NSString*)jsonStr;

+(UIColor*) titleGray ;
+(UIColor*) contentBlack ;
+(UIColor*) green ;
+(UIColor*) orange;
+(UIColor*) background ;
+(UIColor*) line;
+(MBProgressHUD*)showHudInView:(UIView *)view;
+(MBProgressHUD *)showWZHUDWithView:(UIView *)view andString:(NSString *)string ;
/**
 *  本地通知
 */
+ (void)setLocationNoti:(NSString*)bodyString userinfos:(NSDictionary*)userinfo;
/**
 *  秒数转换为时分秒
 */
+(NSString*)TimeformatFromSeconds:(NSInteger)seconds;
/**
 *  显示Here底View
 */
+(UIView*)showHereView;
+(void) showTipAlert:(UIViewController*) controller title:(NSString*) title message:(NSString*) message ;
/**
 *  显示的空状态view
 *
 *  @param tableView view
 *  @param title     文字
 *  @param image     图片
 *
 *  @return 结果view
 */
+(UIView*)showEmptyViewWithView:(UITableView*)tableView title:(NSString*)title image:(UIImage*)image;
/**
 *  获取字符串的size
 *
 *  @param contend 文字
 *  @param font    字号
 *  @param width   长度
 *
 *  @return 结果size
 */
+(CGSize)getSizeWithString:(NSString*)contend font:(CGFloat)font width:(CGFloat)width;
@end
