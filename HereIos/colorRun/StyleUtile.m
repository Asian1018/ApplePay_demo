//
//  StyleUtile.m
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import "StyleUtile.h"

@implementation StyleUtile
+(CGColorRef) loginLayerBound{
    return [UIColor lightGrayColor].CGColor ;
}
+(void) initBoundText:(UITextField *)textField password:(BOOL)isPassword needClean:(BOOL)clean{
    textField.layer.borderColor=[StyleUtile loginLayerBound] ;
    textField.layer.borderWidth = 1 ;
    textField.secureTextEntry=isPassword;
    UIView* leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, textField.frame.size.height)];
    textField.leftViewMode=UITextFieldViewModeAlways ;
    textField.leftView=leftView ;
    textField.backgroundColor=[UIColor whiteColor] ;
    if (clean) {
         textField.clearButtonMode=UITextFieldViewModeAlways ;
    }
   

}
+(UIColor*) greenColor{
    return [Utile colorWithHex:0x29A110 alpha:1] ;
}
@end
