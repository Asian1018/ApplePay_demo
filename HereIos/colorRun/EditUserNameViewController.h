//
//  EditUserNameViewController.h
//  colorRun
//
//  Created by engine on 16/1/27.
//  Copyright © 2016年 engine. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditNameDelegate <NSObject>

-(void) editFinish:(NSString*) userName ;

@end
@interface EditUserNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (strong,nonatomic) User* user ;
@property (strong,nonatomic) id<EditNameDelegate> delegate ;
@end

