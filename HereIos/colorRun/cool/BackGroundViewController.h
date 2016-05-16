//
//  BackGroundViewController.h
//  colorRun
//
//  Created by zhidian on 15/11/30.
//  Copyright © 2015年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGroundViewController : UIViewController
@property(nonatomic) NSInteger userId;
@property(nonatomic, strong) NSString * kilometers;
-(id)initWithKilometers:(NSInteger)userId;
@end
