//
//  StyleUtile.h
//  colorRun
//
//  Created by engine on 16/1/23.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utile.h" 
@interface StyleUtile : NSObject
+(CGColorRef) loginLayerBound ;
+(UIColor*) greenColor ;
+(void) initBoundText:(UITextField*) textField password:(BOOL) isPassword needClean:(BOOL) clean ;
@end
